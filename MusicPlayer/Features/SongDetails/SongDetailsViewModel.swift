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
final class SongDetailsViewModel: ObservableObject {
    @Published var song: Song
    @Published var player: AVPlayer?
    @Published var isPlaying = false
    @Published var showMoreOptionsBottomSheet: Bool = false

    @Published var currentTime: Double = 0
    @Published var duration: Double = 29
    private var timeObserver: Any?

    private var cancellables = Set<AnyCancellable>()

    init(song: Song) {
        self.song = song
        self.setupAVPlayer(url: song.previewUrl)
        self.setupAVAudioSession()

        self.setupPeriodicTimeObserver()
        self.setupPlayerDurationObserver()
        self.setupBinding()
    }

    private func setupBinding() {
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

    private func setupAVPlayer(url: String) {
        guard let url = URL(string: url) else { return }
        player = AVPlayer(url: url)
        player?.automaticallyWaitsToMinimizeStalling = false
    }

    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            // TODO: Show Error Alert.
            print("Failure to configure AVAudioSession: \(error)")
        }
    }

    private func setupPeriodicTimeObserver() {
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

    private func setupPlayerDurationObserver() {
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

    func seek(to seconds: Double) {
        let targetTime = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: targetTime)
    }

    func onDisappear() {
        self.player?.pause()
        self.player = nil
        self.removePeriodicTimeObserver()
    }

    private func removePeriodicTimeObserver() {
//        guard let timeObserver = timeObserver else { return }
//        self.player?.removeTimeObserver(timeObserver)
//        self.timeObserver = nil
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
    }
}
