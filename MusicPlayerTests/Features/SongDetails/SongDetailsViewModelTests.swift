//
//  SongDetailsViewModelTests.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 24/06/25.
//

import SwiftUI
import Testing
import AVFoundation
@testable import MusicPlayer

@Suite("SongDetailsViewModel Tests") struct SongDetailsViewModelTests {

    @MainActor
    @Suite("onPressOpenAlbumButton() Tests") struct onPressOpenAlbumButton {
        let iTunesServiceSpy = ITunesServiceSpy()
        let song = Song.sample()
        lazy var sut: SongDetailsViewModel = {
            return SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy
            )
        }()

        @Test("Should close bottom sheet and open album view when onPressOpenAlbumButton is called.")
        mutating func givenBottomSheetVisible_whenOnPressOpenAlbumButtonCalled_thenBottomSheetClosesAndAlbumViewOpens() {
            // Given
            sut.showMoreOptionsBottomSheet = true
            sut.showAlbumView = false

            // When
            sut.onPressOpenAlbumButton()

            // Then
            #expect(sut.showMoreOptionsBottomSheet == false)
            #expect(sut.showAlbumView == true)
        }
    }

    @MainActor
    @Suite("onSeek() Tests") struct onSeek {
        let iTunesServiceSpy = ITunesServiceSpy()
        let song = Song.sample()
        lazy var avPlayerSpy: AVPlayerSpy = {
            AVPlayerSpy()
        }()
        lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
            var avPlayerFactorySpy = AVPlayerFactorySpy()
            avPlayerFactorySpy.playerToReturn = avPlayerSpy
            return avPlayerFactorySpy
        }()

        @Test("Should call player.seek(to:) with correct time when onSeek is called.")
        mutating func givenValidSeekTime_whenOnSeekCalled_thenPlayerShouldSeekToCorrectTime() {
            // Given
            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )

            // When
            sut.onSeek(to: 10)

            // Then
            #expect(avPlayerSpy.seekCallCount == 1)
            #expect(avPlayerSpy.capturedSeekTime == CMTime(seconds: 10, preferredTimescale: 600))
        }
    }

    @Suite("fetchSongsAndDetailsFromAlbum() Tests") struct fetchSongsAndDetailsFromAlbum {

        @MainActor
        @Suite struct Success {
            let iTunesServiceSpy = ITunesServiceSpy()
            var song = Song.sample()

            lazy var avPlayerSpy: AVPlayerSpy = {
                AVPlayerSpy()
            }()
            lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
                var avPlayerFactorySpy = AVPlayerFactorySpy()
                avPlayerFactorySpy.playerToReturn = avPlayerSpy
                return avPlayerFactorySpy
            }()

            @Test("Should skips network request when song's albumId is empty.")
            mutating func givenSongWithoutAlbumId_whenFetchSongsAndDetailsFromAlbumCalled_thenShouldNotCallServiceAndAlbumSongsRemainsEmpty() async {
                // Given
                song = Song.sample(albumId: nil)
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy
                )

                // When
                await sut.fetchSongsAndDetailsFromAlbum()

                // Then
                #expect(sut.albumSongs.isEmpty)
                #expect(sut.albumDetails == nil)
                #expect(iTunesServiceSpy.fetchSongsAndDetailsFromAlbumCallCount == 0)
            }

            @Test("Should skips network request when song's albumId is empty.")
            mutating func givenSongWithAlbumId_whenFetchSongsAndDetailsFromAlbumCalledWithSuccess_thenShouldCallServiceAndUpdateAlbumSongsAndDetails() async {
                // Given
                let expectedAlbumId: Int = 12345
                song = Song.sample(albumId: expectedAlbumId)

                let expectedResponse = ITunesSongsAndDetailsFromAlbumResponse.sample()

                iTunesServiceSpy.fetchSongsAndDetailsFromAlbumResult = .success(expectedResponse)
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy
                )

                // When
                await sut.fetchSongsAndDetailsFromAlbum()

                // Then
                #expect(sut.albumSongs.count == 2)
                #expect(sut.albumDetails != nil)
                #expect(iTunesServiceSpy.fetchSongsAndDetailsFromAlbumCallCount == 1)
                #expect(iTunesServiceSpy.capturedAlbumId == String(expectedAlbumId))
            }
        }

        @MainActor
        @Suite struct Failure {
            let iTunesServiceSpy = ITunesServiceSpy()
            var song = Song.sample()

            lazy var avPlayerSpy: AVPlayerSpy = {
                AVPlayerSpy()
            }()
            lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
                var avPlayerFactorySpy = AVPlayerFactorySpy()
                avPlayerFactorySpy.playerToReturn = avPlayerSpy
                return avPlayerFactorySpy
            }()

            @Test("Should show error alert and not update album songs and details when service fails with albumId present.")
            mutating func givenSongWithAlbumId_whenFetchSongsAndDetailsFromAlbumFails_thenShouldShowErrorAlertAndNotUpdateAlbumSongsAndDetails() async {
                // Given
                let expectedAlbumId: Int = 12345
                song = Song.sample(albumId: expectedAlbumId)

                iTunesServiceSpy.fetchSongsAndDetailsFromAlbumResult = .failure(URLError(.badServerResponse))
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy
                )

                // When
                await sut.fetchSongsAndDetailsFromAlbum()

                // Then
                #expect(sut.albumSongs.isEmpty)
                #expect(sut.albumDetails == nil)
                #expect(sut.isErrorAlertPresented)
                #expect(sut.errorAlertMessage == "Please try again!")
                #expect(iTunesServiceSpy.fetchSongsAndDetailsFromAlbumCallCount == 1)
                #expect(iTunesServiceSpy.capturedAlbumId == String(expectedAlbumId))
            }
        }
    }

    @MainActor
    @Suite("setupIsPlayingObserver() Tests") struct setupIsPlayingObserver {
        let iTunesServiceSpy = ITunesServiceSpy()
        var song = Song.sample()

        lazy var avPlayerSpy: AVPlayerSpy = {
            AVPlayerSpy()
        }()
        lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
            var avPlayerFactorySpy = AVPlayerFactorySpy()
            avPlayerFactorySpy.playerToReturn = avPlayerSpy
            return avPlayerFactorySpy
        }()

        @Test("Should pause player on initialization and not trigger play.")
        mutating func givenViewModelInitialization_whenInit_thenPlayerShouldBePausedAndNotPlaying() {
            // Given
            _ = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )

            // When
            // Then
            #expect(avPlayerSpy.playCallCount == 0)
            #expect(avPlayerSpy.pauseCallCount == 1)
        }

        @Test("Should call play on AVPlayer when isPlaying becomes true.")
        mutating func givenViewModel_whenIsPlayingBecomesTrue_thenShouldCallPlayOnAVPlayer() {
            // Given
            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )

            // When
            sut.isPlaying = true

            // Then
            #expect(avPlayerSpy.playCallCount == 1)
            #expect(avPlayerSpy.pauseCallCount == 1)
        }

        @Test("Should call pause on AVPlayer when isPlaying becomes false.")
        mutating func givenViewModel_whenIsPlayingBecomesFalse_thenShouldCallPauseOnAVPlayer() {
            // Given
            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )

            // When
            sut.isPlaying = true
            sut.isPlaying = false

            // Then
            #expect(avPlayerSpy.playCallCount == 1)
            #expect(avPlayerSpy.pauseCallCount == 2)
        }
    }

    @MainActor
    @Suite("onDisappear() Tests") struct onDisappear {
        let iTunesServiceSpy = ITunesServiceSpy()
        var song = Song.sample()

        lazy var avPlayerSpy: AVPlayerSpy = {
            AVPlayerSpy()
        }()
        lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
            var avPlayerFactorySpy = AVPlayerFactorySpy()
            avPlayerFactorySpy.playerToReturn = avPlayerSpy
            return avPlayerFactorySpy
        }()

        @Test("Should cancel subscriptions when view disappears.")
        mutating func givenActivePlayerAndSubscriptions_whenOnDisappearCalled_thenDeleteCancellables() {
            // Given
            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )
            // When
            sut.onDisappear()

            // Then
            #expect(sut.cancellables.isEmpty)
        }

        @Test("Should reset player when view disappears.")
        mutating func givenActivePlayerAndSubscriptions_whenOnDisappearCalled_thenCallResetPlayerFunction() {
            // Given
            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )
            // When
            sut.onDisappear()

            // Then
            #expect(sut.currentTime == 0)
            #expect(sut.player == nil)
            #expect(avPlayerSpy.seekCallCount == 1)
            #expect(avPlayerSpy.removeTimeObserverCallCount == 1)
            #expect(avPlayerSpy.removedTimeObservers.count == 1)
        }
    }

    @MainActor
    @Suite("onBackward() Tests") struct onBackward {
        let iTunesServiceSpy = ITunesServiceSpy()
        var song = Song.sample()

        lazy var avPlayerSpy: AVPlayerSpy = {
            AVPlayerSpy()
        }()
        lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
            var avPlayerFactorySpy = AVPlayerFactorySpy()
            avPlayerFactorySpy.playerToReturn = avPlayerSpy
            return avPlayerFactorySpy
        }()

        @Test("Should not change song or interact with player when already at first song in album.")
        mutating func givenFirstSongInAlbum_whenOnBackwardCalled_thenShouldDoNothing() {
            // Given
            let expectedAlbumSongs = Album.sampleAlbumSongs(albumTrackCount: 2)
            song = expectedAlbumSongs[0]

            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )
            sut.albumDetails = Album.sample(trackCount: 2)
            sut.albumSongs = expectedAlbumSongs

            // When
            sut.onBackward()

            // Then
            #expect(sut.song == expectedAlbumSongs[0])
            #expect(avPlayerSpy.seekCallCount == 0)
            #expect(avPlayerSpy.removeTimeObserverCallCount == 0)
            #expect(avPlayerSpy.removedTimeObservers.count == 0)
        }

        @Test("Should switch to previous song and reset player when not at first song in album.")
        mutating func givenSecondSongInAlbum_whenOnBackwardCalled_thenShouldSwitchToPreviousSongAndResetPlayer() {
            // Given
            let expectedAlbumSongs = Album.sampleAlbumSongs(albumTrackCount: 2)
            song = expectedAlbumSongs[1]

            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )
            sut.albumDetails = Album.sample(trackCount: 2)
            sut.albumSongs = expectedAlbumSongs

            // When
            sut.onBackward()

            // Then
            #expect(sut.song == expectedAlbumSongs[0])
            #expect(avPlayerSpy.seekCallCount == 1)
            #expect(avPlayerSpy.removeTimeObserverCallCount == 1)
            #expect(avPlayerSpy.removedTimeObservers.count == 1)
        }
    }

    @MainActor
    @Suite("onForward() Tests") struct onForward {
        let iTunesServiceSpy = ITunesServiceSpy()
        var song = Song.sample()

        lazy var avPlayerSpy: AVPlayerSpy = {
            AVPlayerSpy()
        }()
        lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
            var avPlayerFactorySpy = AVPlayerFactorySpy()
            avPlayerFactorySpy.playerToReturn = avPlayerSpy
            return avPlayerFactorySpy
        }()

        @Test("Should switch to next song and reset player when isn't at last song in album.")
        mutating func givenFirstSongInAlbum_whenOnForwardCalled_thenShouldSwitchToNextSongAndResetPlayer() {
            // Given
            let expectedAlbumSongs = Album.sampleAlbumSongs(albumTrackCount: 2)
            song = expectedAlbumSongs[0]

            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )
            sut.albumDetails = Album.sample(trackCount: 2)
            sut.albumSongs = expectedAlbumSongs

            // When
            sut.onForward()

            // Then
            #expect(sut.song == expectedAlbumSongs[1])
            #expect(avPlayerSpy.seekCallCount == 1)
            #expect(avPlayerSpy.removeTimeObserverCallCount == 1)
            #expect(avPlayerSpy.removedTimeObservers.count == 1)
        }

        @Test("Should not change song or interact with player when already at last song in album.")
        mutating func givenLastSongInAlbum_whenOnForwardCalled_thenShouldDoNothing() {
            // Given
            let expectedAlbumSongs = Album.sampleAlbumSongs(albumTrackCount: 2)
            song = expectedAlbumSongs[1]

            let sut = SongDetailsViewModel(
                song: song,
                iTunesService: iTunesServiceSpy,
                avPlayerFactory: avPlayerFactorySpy
            )
            sut.albumDetails = Album.sample(trackCount: 2)
            sut.albumSongs = expectedAlbumSongs

            // When
            sut.onForward()

            // Then
            #expect(sut.song == expectedAlbumSongs[1])
            #expect(avPlayerSpy.seekCallCount == 0)
            #expect(avPlayerSpy.removeTimeObserverCallCount == 0)
            #expect(avPlayerSpy.removedTimeObservers.count == 0)
        }
    }

    @Suite("setupAVAudioSession() Tests") struct setupAVAudioSession {

        @MainActor
        @Suite struct Success {
            let iTunesServiceSpy = ITunesServiceSpy()
            var song = Song.sample()

            lazy var avPlayerSpy: AVPlayerSpy = {
                AVPlayerSpy()
            }()
            lazy var avAudioSessionSpy: AVAudioSessionSpy = {
                AVAudioSessionSpy()
            }()
            lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
                var avPlayerFactorySpy = AVPlayerFactorySpy()
                avPlayerFactorySpy.playerToReturn = avPlayerSpy
                return avPlayerFactorySpy
            }()

            @Test("Should configure and activate AVAudioSession on ViewModel initialization when no errors occur.")
            mutating func givenViewModelInitialization_whenSetupAudioSessionSucceeds_thenShouldSetCategoryAndActivateSession() {
                // Given
                // When
                _ = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(avAudioSessionSpy.setCategoryCallCount == 1)
                #expect(avAudioSessionSpy.capturedCategory == .playback)
                #expect(avAudioSessionSpy.capturedMode == .default)
                #expect(avAudioSessionSpy.capturedSetCategoryOptions == [])
                #expect(avAudioSessionSpy.setCategoryErrorToThrow == nil)

                #expect(avAudioSessionSpy.setActiveCallCount == 1)
                #expect(avAudioSessionSpy.capturedActiveState == true)
                #expect(avAudioSessionSpy.capturedSetActiveOptions == [])
                #expect(avAudioSessionSpy.setActiveErrorToThrow == nil)
            }
        }

        @MainActor
        @Suite struct Failure {
            let iTunesServiceSpy = ITunesServiceSpy()
            var song = Song.sample()

            lazy var avPlayerSpy: AVPlayerSpy = {
                AVPlayerSpy()
            }()
            lazy var avAudioSessionSpy: AVAudioSessionSpy = {
                AVAudioSessionSpy()
            }()
            lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
                var avPlayerFactorySpy = AVPlayerFactorySpy()
                avPlayerFactorySpy.playerToReturn = avPlayerSpy
                return avPlayerFactorySpy
            }()

            @Test("Should not activate AVAudioSession and should show error alert when setCategory fails during ViewModel init.")
            mutating func givenViewModelInitialization_whenSetCategoryFails_thenShouldNotCallSetActiveAndShowErrorAlert() {
                // Given
                let errorToThrow = CommonsErrors.generic
                avAudioSessionSpy.setCategoryErrorToThrow = errorToThrow

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(avAudioSessionSpy.setCategoryCallCount == 1)
                #expect(avAudioSessionSpy.capturedCategory == .playback)
                #expect(avAudioSessionSpy.capturedMode == .default)
                #expect(avAudioSessionSpy.capturedSetCategoryOptions == [])
                #expect(avAudioSessionSpy.setCategoryErrorToThrow as! CommonsErrors == errorToThrow)

                #expect(avAudioSessionSpy.setActiveCallCount == 0)
                #expect(avAudioSessionSpy.capturedActiveState == nil)
                #expect(avAudioSessionSpy.capturedSetActiveOptions == nil)
                #expect(avAudioSessionSpy.setActiveErrorToThrow == nil)
                #expect(sut.isErrorAlertPresented)
            }

            @Test("Should skip setActive and show error alert when setCategory fails during ViewModel initialization.")
            mutating func givenViewModelInitialization_whenSetCategoryFails_thenShouldSkipSetActiveAndShowErrorAlert() {
                // Given
                let errorToThrow = CommonsErrors.generic
                avAudioSessionSpy.setActiveErrorToThrow = errorToThrow

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(avAudioSessionSpy.setCategoryCallCount == 1)
                #expect(avAudioSessionSpy.capturedCategory == .playback)
                #expect(avAudioSessionSpy.capturedMode == .default)
                #expect(avAudioSessionSpy.capturedSetCategoryOptions == [])
                #expect(avAudioSessionSpy.setCategoryErrorToThrow == nil)

                #expect(avAudioSessionSpy.setActiveCallCount == 1)
                #expect(avAudioSessionSpy.capturedActiveState == true)
                #expect(avAudioSessionSpy.capturedSetActiveOptions == [])
                #expect(avAudioSessionSpy.setActiveErrorToThrow as! CommonsErrors == errorToThrow)
                #expect(sut.isErrorAlertPresented)
            }
        }
    }

    @Suite("bindSongChangesToPlayer() Tests") struct bindSongChangesToPlayer {

        @MainActor
        @Suite struct Success {
            let iTunesServiceSpy = ITunesServiceSpy()
            var song = Song.sample()

            lazy var avPlayerSpy: AVPlayerSpy = {
                AVPlayerSpy()
            }()
            lazy var avAudioSessionSpy: AVAudioSessionSpy = {
                AVAudioSessionSpy()
            }()
            lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
                var avPlayerFactorySpy = AVPlayerFactorySpy()
                avPlayerFactorySpy.playerToReturn = avPlayerSpy
                return avPlayerFactorySpy
            }()

            @Test("Should call AVPlayerFactory and not show error when setupAVPlayer is called by bindSongChangesToPlayer during ViewModel init.")
            mutating func givenAVPlayerFactorySucceeds_whenSetupAVPlayerIsCalledByBindSongChangesToPlayerInInit_thenShouldCreatePlayerWithoutError() {
                // Given
                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(avPlayerFactorySpy.errorToThrow == nil)
                #expect(avPlayerFactorySpy.receivedURLs[0] == song.previewUrl)
                #expect(avPlayerFactorySpy.callCount == 1)
                #expect(avPlayerSpy.automaticallyWaitsToMinimizeStalling == false)
                #expect(sut.isErrorAlertPresented == false)
            }


            @Test("Should disable forward and backward buttons when song has no album information when updateAudioPlayerButtonsAvailability is called by bindSongChangesToPlayer during ViewModel init.")
            mutating func givenSongWithoutAlbumInfo_whenViewModelInit_thenForwardAndBackwardButtonsAreDisabled() {
                // Given
                song = Song.sample(
                    albumId: nil,
                    albumName: nil,
                    albumTrackCount: nil
                )

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(sut.isForwardButtonAvailable == false)
                #expect(sut.isBackwardButtonAvailable == false)
            }

            @Test("Should disable forward and backward buttons when song has albumId but missing albumName and albumTrackCount, when updateAudioPlayerButtonsAvailability is called by bindSongChangesToPlayer during ViewModel init.")
            mutating func givenSongWithAlbumIdButMissingAlbumNameAndTrackCount_whenViewModelInitTriggersBindSongChangesToPlayer_thenForwardAndBackwardButtonsAreDisabled() {
                // Given
                song = Song.sample(
                    albumId: 1,
                    albumName: nil,
                    albumTrackCount: nil
                )

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(sut.isForwardButtonAvailable == false)
                #expect(sut.isBackwardButtonAvailable == false)
            }

            @Test("Should disable forward and backward buttons when song has albumId and albumName but missing albumTrackCount, when updateAudioPlayerButtonsAvailability is called by bindSongChangesToPlayer during ViewModel init.")
            mutating func givenSongWithAlbumIdAndAlbumNameButMissingAlbumTrackCount_whenViewModelInitTriggersBindSongChangesToPlayer_thenForwardAndBackwardButtonsAreDisabled() {
                // Given
                song = Song.sample(
                    albumId: 1,
                    albumName: "Name",
                    albumTrackCount: nil
                )

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(sut.isForwardButtonAvailable == false)
                #expect(sut.isBackwardButtonAvailable == false)
            }

            @Test("Should enable forward and disable backward button when song is first track in album and updateAudioPlayerButtonsAvailability is called by bindSongChangesToPlayer during ViewModel init.")
            mutating func givenFirstSongInAlbum_whenViewModelInitTriggersBindSongChangesToPlayer_thenForwardButtonIsEnabledAndBackwardButtonIsDisabled() {
                // Given
                song = Song.sample(
                    albumId: 1,
                    albumName: "Name",
                    trackNumber: 1,
                    albumTrackCount: 2
                )

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(sut.isForwardButtonAvailable == true)
                #expect(sut.isBackwardButtonAvailable == false)
            }

            @Test("Should disable forward and enable backward button when song is last track in album and updateAudioPlayerButtonsAvailability is called by bindSongChangesToPlayer during ViewModel init.")
            mutating func givenLastSongInAlbum_whenViewModelInitTriggersBindSongChangesToPlayer_thenForwardButtonIsDisabledAndBackwardButtonIsEnabled() {
                // Given
                song = Song.sample(
                    albumId: 1,
                    albumName: "Name",
                    trackNumber: 2,
                    albumTrackCount: 2
                )

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(sut.isForwardButtonAvailable == false)
                #expect(sut.isBackwardButtonAvailable == true)
            }

            @Test("Should disable both forward and backward buttons when song is the only track in album and updateAudioPlayerButtonsAvailability is called by bindSongChangesToPlayer during ViewModel init.")
            mutating func givenSingleTrackAlbum_whenViewModelInitTriggersBindSongChangesToPlayer_thenForwardAndBackwardButtonsAreDisabled() {
                // Given
                song = Song.sample(
                    albumId: 1,
                    albumName: "Name",
                    trackNumber: 1,
                    albumTrackCount: 1
                )

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )

                // Then
                #expect(sut.isForwardButtonAvailable == false)
                #expect(sut.isBackwardButtonAvailable == false)
            }
        }

        @MainActor
        @Suite struct Failure {
            let iTunesServiceSpy = ITunesServiceSpy()
            var song = Song.sample()

            lazy var avPlayerSpy: AVPlayerSpy = {
                AVPlayerSpy()
            }()
            lazy var avAudioSessionSpy: AVAudioSessionSpy = {
                AVAudioSessionSpy()
            }()
            lazy var avPlayerFactorySpy: AVPlayerFactorySpy = {
                var avPlayerFactorySpy = AVPlayerFactorySpy()
                avPlayerFactorySpy.playerToReturn = avPlayerSpy
                return avPlayerFactorySpy
            }()

            @Test("Should show error alert when when setupAVPlayer is called by bindSongChangesToPlayer and AVPlayerFactory throws error during ViewModel init.")
            mutating func givenAVPlayerFactoryThrowsError_whenSetupAVPlayerIsCalledInViewModelInit_thenShouldShowErrorAlert() {
                // Given
                let errorToThrow = CommonsErrors.invalidURL
                avPlayerFactorySpy.errorToThrow = errorToThrow

                // When
                let sut = SongDetailsViewModel(
                    song: song,
                    iTunesService: iTunesServiceSpy,
                    avPlayerFactory: avPlayerFactorySpy,
                    avAudioSession: avAudioSessionSpy
                )
                // Then
                #expect(sut.isErrorAlertPresented)
                #expect(avPlayerFactorySpy.errorToThrow as! CommonsErrors == errorToThrow)
                #expect(avPlayerFactorySpy.receivedURLs[0] == song.previewUrl)
                #expect(avPlayerFactorySpy.callCount == 1)
            }
        }
    }
    //    @Suite("showErrorAlert() Tests") struct fetchMusicList {
    //
    //        @Suite struct Success {
    //            @Test func given_when_then() {
    //                // Given
    //                // When
    //                // Then
    //            }
    //        }
    //
    //        @Suite struct Failure {}
    //    }
}
