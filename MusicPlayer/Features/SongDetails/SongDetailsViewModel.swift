//
//  SongDetailsViewModel.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import Combine
import SwiftUI
import AVFoundation

@MainActor
class SongDetailsViewModel: ErrorAlertViewModel {
    @Published var song: Song
    @Published var albumSongs: [Song] = []
    @Published var albumDetails: Album?
    @Published var player: AVPlayer?
    @Published var isPlaying = false

    @Published var isForwardButtonAvailable = false
    @Published var isBackwardButtonAvailable = false

    @Published var showMoreOptionsBottomSheet: Bool = false
    @Published var showAlbumView: Bool = false

    @Published var currentTime: Double = 0
    @Published var duration: Double = 29
    private var timeObserver: Any?

    private let iTunesService: ITunesServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(song: Song, iTunesService: ITunesServiceProtocol = ITunesService()) {
        self.song = song
        self.iTunesService = iTunesService

        super.init()

        self.setupAVAudioSession()

        self.bindSongChangesToPlayer()
        self.setupIsPlayingObserver()
        Task {
            await self.fetchSongsAndDetailsFromAlbum()
        }
    }

    func onDisappear() {
        cancellables.removeAll()
        self.resetPlayer()
    }

    func onPressOpenAlbumButton() {
        showMoreOptionsBottomSheet = false
        showAlbumView = true
    }

    func onSeek(to seconds: Double) {
        let targetTime = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: targetTime)
    }

    func fetchSongsAndDetailsFromAlbum() async {
        Task { @MainActor [iTunesService] in
            do {
                let response: ITunesSongsAndDetailsFromAlbumResponse = try await iTunesService.fetchSongsAndDetailsFromAlbum(withId: String(song.albumId))

                var fetchedSongs: [Song] = []

                for result in response.results {
                    switch result {
                    case .song(let song):
                        fetchedSongs.append(song)
                    case .album(let album):
                        self.albumDetails = album
                    }
                }

                fetchedSongs.sort { ($0.trackNumber) < ($1.trackNumber) }
                self.albumSongs = fetchedSongs
            } catch {
                showErrorAlert()
            }
        }
    }
}

// MARK: AudioPlayerButtons Functions
extension SongDetailsViewModel {
    func onBackward() {
        let isFirstSong = song.trackNumber == 1
        if !isFirstSong {
            resetPlayer()
            if let previousSong = albumSongs.first(where: { $0.trackNumber == song.trackNumber - 1 }) {
                self.song = previousSong
            }
        }
    }

    func onForward() {
        let isLastSong = song.trackNumber == albumDetails?.trackCount
        if !isLastSong {
            resetPlayer()
            if let nextSong = albumSongs.first(where: { $0.trackNumber == song.trackNumber + 1 }) {
                self.song = nextSong
            }
        }
    }
}

private extension SongDetailsViewModel {
    func setupIsPlayingObserver() {
        $isPlaying
            .removeDuplicates()
            .sink { [weak self] isPlaying in
                guard let self = self else { return }
                if isPlaying {
                    player?.play()
                } else {
                    player?.pause()
                }
            }
            .store(in: &cancellables)
    }

    func bindSongChangesToPlayer() {
        $song
            .removeDuplicates()
            .sink { [weak self] song in
                self?.resetPlayer()
                self?.setupAVPlayer(url: song.previewUrl)
                self?.setupPeriodicTimeObserver()
                self?.setupPlayerDurationObserver()
                self?.updateAudioPlayerButtonsAvailability(song: song)
            }
            .store(in: &cancellables)
    }

    func updateAudioPlayerButtonsAvailability(song: Song) {
        let isLastSong = song.trackNumber == self.albumDetails?.trackCount
        self.isForwardButtonAvailable = !isLastSong

        let isFirstSong = song.trackNumber == 1
        self.isBackwardButtonAvailable = !isFirstSong
    }

    func setupAVPlayer(url: String) {
        guard let url = URL(string: url) else { return }
        player = AVPlayer(url: url)
        player?.automaticallyWaitsToMinimizeStalling = false
    }

    func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            showErrorAlert()
            print("Failure to configure AVAudioSession: \(error)")
        }
    }

    func setupPeriodicTimeObserver() {
        guard let player = player else { return }
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)

        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            Task { @MainActor in
                guard let self = self else { return }
                self.currentTime = time.seconds
                if let durationSeconds = player.currentItem?.duration.seconds, durationSeconds.isFinite {
                    self.duration = durationSeconds - time.seconds
                }
            }
        }
    }

    func setupPlayerDurationObserver() {
        player?.currentItem?.publisher(for: \.status, options: [.initial, .new])
            .sink { [weak self] status in
                guard let self = self else { return }
                if status == .readyToPlay,
                   let durationSeconds = self.player?.currentItem?.duration.seconds,
                   durationSeconds.isFinite {
                    self.duration = durationSeconds
                }
            }
            .store(in: &cancellables)
    }

    func removePeriodicTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }

    func resetPlayer() {
        self.currentTime = 0
        self.onSeek(to: 0)
        self.isPlaying = false
        self.player?.pause()
        self.player = nil
        self.removePeriodicTimeObserver()
    }
}
