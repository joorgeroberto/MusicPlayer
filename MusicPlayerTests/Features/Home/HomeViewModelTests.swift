//
//  HomeViewModelTests.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 23/06/25.
//

import Combine
import SwiftUI
import Testing
@testable import MusicPlayer

@Suite("HomeViewModelTests Tests") struct HomeViewModelTests {
    @MainActor
    @Suite("showEmptyState() Tests") struct showEmptyState {
        let iTunesServiceSpy = ITunesServiceSpy()
        lazy var sut: HomeViewModel = {
            return HomeViewModel(iTunesService: iTunesServiceSpy)
        }()

        @Test mutating func givenPopulatedSearchTerm_whenShowEmptyStateFunctionIsCalled_thenShowEmptyStateFunctionShouldReturnFalse() {
            // Given
            sut.searchTerm = "Search Term"

            // When
            let showEmptyState = sut.showEmptyState()

            // Then
            #expect(showEmptyState == false)
        }

        @Test mutating func givenEmptySearchTerm_whenShowEmptyStateFunctionIsCalled_thenShowEmptyStateFunctionShouldReturnTrue() {
            // Given
            sut.searchTerm = ""

            // When
            let showEmptyState = sut.showEmptyState()

            // Then
            #expect(showEmptyState)
        }
    }

    @MainActor
    @Suite("showProgressView() Tests") struct showProgressView {
        let iTunesServiceSpy = ITunesServiceSpy()
        lazy var sut: HomeViewModel = {
            return HomeViewModel(iTunesService: iTunesServiceSpy)
        }()

        @Test("Empty Songs array and if is NOT fetching Music List, should return false.")
        mutating func givenEmptySongsArrayAndIsNotFetchingMusicList_whenShowProgressViewFunctionIsCalled_thenShowEmptyStateFunctionShouldReturnFalse() {
            // Given
            sut.isFetchingMusicList = false
            sut.songs = []

            // When
            let showProgressView = sut.showProgressView()

            // Then
            #expect(showProgressView == false)
        }

        @Test("Empty Songs array and if is fetching Music List, should return true.")
        mutating func givenEmptySongsArrayAndIsFetchingMusicList_whenShowProgressViewFunctionIsCalled_thenShowEmptyStateFunctionShouldReturnTrue() {
            // Given
            sut.isFetchingMusicList = true
            sut.songs = []

            // When
            let showProgressView = sut.showProgressView()

            // Then
            #expect(showProgressView)
        }

        @Test("Populated Songs array and if is fetching Music List, should return false.")
        mutating func givenPopulatedSongsArrayAndIsFetchingMusicList_whenShowProgressViewFunctionIsCalled_thenShowEmptyStateFunctionShouldReturnFalse() {
            // Given
            sut.isFetchingMusicList = true
            sut.songs = [Song.sample()]

            // When
            let showProgressView = sut.showProgressView()

            // Then
            #expect(showProgressView == false)
        }

        @Test("Populated Songs array and if is NOT fetching Music List, should return false.")
        mutating func givenPopulatedSongsArrayAndIsNotFetchingMusicList_whenShowProgressViewFunctionIsCalled_thenShowEmptyStateFunctionShouldReturnFalse() {
            // Given
            sut.isFetchingMusicList = true
            sut.songs = [Song.sample()]

            // When
            let showProgressView = sut.showProgressView()

            // Then
            #expect(showProgressView == false)
        }
    }


    @Suite("fetchMusicList() Tests") struct fetchMusicList {
        @MainActor
        @Suite struct Success {
            let iTunesServiceSpy = ITunesServiceSpy()
            lazy var sut: HomeViewModel = {
                return HomeViewModel(iTunesService: iTunesServiceSpy)
            }()

            @Test("Clears songs and skips network request when search term is empty and not currently fetching.")
            mutating func givenEmptySearchTermAndIsNotFetchingMusicList_whenFetchMusicListIsCalled_thenSongsArrayShouldBeClearedAndNoRequestMade() async {
                // Given
                sut.searchTerm = ""
                sut.isFetchingMusicList = false
                sut.songs = [Song.sample()]

                // When
                _ = await sut.fetchMusicList()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 0)
            }


            @Test("Should clear songs and skip network request when search term is empty and is already fetching.")
            mutating func givenEmptySearchTermAndIsFetchingMusicList_whenFetchMusicListIsCalled_thenSongsArrayShouldBeClearedAndNoRequestMade() async {
                // Given
                sut.searchTerm = ""
                sut.isFetchingMusicList = true
                sut.songs = [Song.sample()]

                // When
                _ = await sut.fetchMusicList()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 0)
            }

            @Test("Should clear songs and skip network request when search term is populated and is already fetching.")
            mutating func givenPopulatedSearchTermAndIsFetchingMusicList_whenFetchMusicListIsCalled_thenSongsArrayShouldBeClearedAndNoRequestMade() async {
                // Given
                sut.searchTerm = "Search Term"
                sut.isFetchingMusicList = true
                sut.songs = [Song.sample()]

                // When
                _ = await sut.fetchMusicList()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 0)
            }

            @Test("Given populated search term and not fetching music list, when fetchMusicList is called and service returns success, then songs array and offset should be updated.")
            mutating func givenPopulatedSearchTermAndNotFetchingMusicList_whenFetchMusicListReturnsSuccess_thenSongsAndOffsetAreUpdated() async {
                // Given
                let expectedResponse = ITunesSearchResponse(
                    resultCount: 1,
                    results: [Song.sample()]
                )
                let expectedSearchTerm = "Search Term"
                let expectedOffset = 50

                iTunesServiceSpy.fetchMusicListResult = .success(expectedResponse)
                sut = HomeViewModel(iTunesService: iTunesServiceSpy)
                sut.searchTerm = expectedSearchTerm
                sut.isFetchingMusicList = false
                sut.songs = []

                // When
                await sut.fetchMusicList()

                // Then
                #expect(sut.songs.count == 1)
                #expect(sut.offset == expectedOffset)
                #expect(sut.isLoadingMore == false)
                #expect(iTunesServiceSpy.capturedTerm == expectedSearchTerm)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 1)
            }
        }

        @MainActor
        @Suite struct Failure {
            let iTunesServiceSpy = ITunesServiceSpy()
            lazy var sut: HomeViewModel = {
                return HomeViewModel(iTunesService: iTunesServiceSpy)
            }()

            @Test("Given populated search term and not fetching music list, when fetchMusicList is called and service returns failure, then songs should remain empty, offset should stay at 0, searchTerm should be cleared, and error alert should be shown.")
            mutating func givenPopulatedSearchTermAndNotFetchingMusicList_whenFetchMusicListFails_thenSearchTermAreResetAndErrorAlertIsShown() async {
                // Given
                let expectedOffset = 0
                iTunesServiceSpy.fetchMusicListResult = .failure(URLError(.badServerResponse))
                sut = HomeViewModel(iTunesService: iTunesServiceSpy)
                sut.searchTerm = "Search Term"
                sut.isFetchingMusicList = false
                sut.songs = []

                // When
                await sut.fetchMusicList()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(sut.offset == expectedOffset)
                #expect(sut.searchTerm.isEmpty)
                #expect(sut.isErrorAlertPresented)

                #expect(iTunesServiceSpy.capturedOffset == expectedOffset)
                #expect(iTunesServiceSpy.capturedOffset == 0)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 1)
            }
        }
    }

    @Suite("setupSearchDebounce() Tests") struct setupSearchDebounce {

        @MainActor
        @Suite struct Success {
            let iTunesServiceSpy = ITunesServiceSpy()
            lazy var sut: HomeViewModel = {
                return HomeViewModel(iTunesService: iTunesServiceSpy)
            }()

            @Test("Given search term, when debounce completes, then fetchMusicList should be called once, returns success and songs updated.")
            mutating func givenSearchTerm_whenDebounceCompletes_thenFetchMusicListIsCalledOnceAndSongsAreUpdated() async {
                // Given
                let expectedResponse = ITunesSearchResponse(
                    resultCount: 1,
                    results: [Song.sample()]
                )
                let expectedSearchTerm = "Search Term"
                let expectedOffset = 50

                iTunesServiceSpy.fetchMusicListResult = .success(expectedResponse)
                sut = HomeViewModel(iTunesService: iTunesServiceSpy)
                sut.searchTerm = expectedSearchTerm
                sut.isFetchingMusicList = false
                sut.songs = []

                // When
                await confirmation(expectedCount: 1) { confirm in
                    iTunesServiceSpy.onFetchMusicListCalled = {
                        confirm()
                    }
                    sut.searchTerm = expectedSearchTerm
                    try? await Task.sleep(for: .milliseconds(2_000))  // 2 seconds
                }

                // Then
                #expect(sut.songs.count == 1)
                #expect(sut.offset == expectedOffset)
                #expect(iTunesServiceSpy.capturedTerm == expectedSearchTerm)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 1)
            }
        }

        @MainActor
        @Suite struct Failure {
            let iTunesServiceSpy = ITunesServiceSpy()
            lazy var sut: HomeViewModel = {
                return HomeViewModel(iTunesService: iTunesServiceSpy)
            }()

            @Test("Given search term, when debounce completes, then fetchMusicList should be called once, returns failure and songs not are updated.")
            mutating func givenSearchTerm_whenDebounceCompletes_thenFetchMusicListIsCalledOnceAndSongsNotAreUpdated() async {
                // Given
                let expectedSearchTerm = "Search Term"
                let expectedOffset = 0

                iTunesServiceSpy.fetchMusicListResult = .failure(URLError(.badServerResponse))
                sut = HomeViewModel(iTunesService: iTunesServiceSpy)
                sut.searchTerm = expectedSearchTerm
                sut.isFetchingMusicList = false
                sut.songs = []

                // When
                await confirmation(expectedCount: 1) { confirm in
                    iTunesServiceSpy.onFetchMusicListCalled = {
                        confirm()
                    }
                    sut.searchTerm = expectedSearchTerm
                    try? await Task.sleep(for: .milliseconds(2_000))  // 2 seconds
                }

                // Then
                #expect(sut.songs.isEmpty)
                #expect(sut.offset == expectedOffset)
                #expect(sut.searchTerm.isEmpty)
                #expect(sut.isErrorAlertPresented)

                #expect(iTunesServiceSpy.capturedOffset == expectedOffset)
                #expect(iTunesServiceSpy.capturedOffset == 0)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 1)
            }
        }
    }

    @Suite("loadMore() Tests") struct loadMore {
        @MainActor
        @Suite struct Success {
            let iTunesServiceSpy = ITunesServiceSpy()
            lazy var sut: HomeViewModel = {
                return HomeViewModel(iTunesService: iTunesServiceSpy)
            }()

            @Test("Should skips network request when search term is empty and not currently fetching.")
            mutating func givenEmptySearchTermAndIsNotLoadingMore_whenLoadMoreIsCalled_thenNoRequestShouldBeMade() async {
                // Given
                sut.searchTerm = ""
                sut.isLoadingMore = false

                // When
                _ = await sut.loadMore()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(sut.offset == 0)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 0)
            }

            @Test("Should skips network request when search term is populated and not currently fetching.")
            mutating func givenEmptySearchTermAndIsLoadingMore_whenLoadMoreIsCalled_thenNoRequestShouldBeMade() async {
                // Given
                sut.searchTerm = ""
                sut.isLoadingMore = true

                // When
                _ = await sut.loadMore()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(sut.offset == 0)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 0)
            }

            @Test("Should skip network request when search term is populated and is already fetching.")
            mutating func givenPopulatedSearchTermAndIsLoadingMore_whenLoadMoreIsCalled_thenNoRequestShouldBeMade() async {
                // Given
                sut.searchTerm = "Search Term"
                sut.isLoadingMore = true

                // When
                _ = await sut.loadMore()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(sut.offset == 0)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 0)
            }

            @Test("Should update songs and offset when search term is populated and service returns success.")
            mutating func givenPopulatedSearchTermAndNotLoadingMore_whenFetchMusicListReturnsSuccess_thenSongsAndOffsetAreUpdated() async {
                // Given
                let expectedResponse = ITunesSearchResponse(
                    resultCount: 2,
                    results: [
                        Song.sample(),
                        Song.sample()
                    ]
                )
                let expectedSearchTerm = "Search Term"
                let expectedOffset = 50

                iTunesServiceSpy.fetchMusicListResult = .success(expectedResponse)
                sut = HomeViewModel(iTunesService: iTunesServiceSpy)
                sut.searchTerm = expectedSearchTerm
                sut.isLoadingMore = false
                sut.songs = []

                // When
                await sut.loadMore()

                // Then
                #expect(sut.songs.count == 2)
                #expect(sut.offset == expectedOffset)
                #expect(sut.isLoadingMore == false)
                #expect(iTunesServiceSpy.capturedTerm == expectedSearchTerm)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 1)
            }

            @Test("Should not append songs with duplicate trackId when loading more results")
            mutating func givenPopulatedSearchTermAndNotLoadingMore_whenFetchMusicListReturnsSuccessWithDuplicateTrackIdsInResponse_thenOnlyUniqueSongsAreAppended() async {
                // Given
                let existingSong = Song.sample(trackId: 1)
                let expectedOffset = 50
                let expectedSearchTerm = "Search Term"
                sut.songs = [existingSong]
                sut.searchTerm = expectedSearchTerm

                let duplicateSong = Song.sample(trackId: 1)
                let newSong = Song.sample(trackId: 2)
                let expectedResultTrackIds = [1, 2]

                let expectedResponse = ITunesSearchResponse(
                    resultCount: 2,
                    results: [
                        duplicateSong,
                        newSong
                    ]
                )
                iTunesServiceSpy.fetchMusicListResult = .success(expectedResponse)

                // When
                await sut.loadMore()

                // Then

                #expect(expectedResultTrackIds == [1, 2])
                #expect(sut.songs.count == 2)
                #expect(sut.offset == expectedOffset)
                #expect(sut.isLoadingMore == false)
                #expect(iTunesServiceSpy.capturedTerm == expectedSearchTerm)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 1)
            }
        }

        @MainActor
        @Suite struct Failure {
            let iTunesServiceSpy = ITunesServiceSpy()
            lazy var sut: HomeViewModel = {
                return HomeViewModel(iTunesService: iTunesServiceSpy)
            }()

            @Test("Should clear search term and show error alert when loadMore fails with populated search term and not already loading more.")
            mutating func givenPopulatedSearchTermAndNotIsLoadingMore_whenFetchMusicListFails_thenSearchTermAreResetAndErrorAlertIsShown() async {
                // Given
                let expectedOffset = 0
                iTunesServiceSpy.fetchMusicListResult = .failure(URLError(.badServerResponse))
                sut = HomeViewModel(iTunesService: iTunesServiceSpy)
                sut.searchTerm = "Search Term"
                sut.isFetchingMusicList = false
                sut.songs = []

                // When
                await sut.loadMore()

                // Then
                #expect(sut.songs.isEmpty)
                #expect(sut.offset == expectedOffset)
                #expect(sut.searchTerm.isEmpty)
                #expect(sut.isErrorAlertPresented)

                #expect(iTunesServiceSpy.capturedOffset == expectedOffset)
                #expect(iTunesServiceSpy.capturedOffset == 0)
                #expect(iTunesServiceSpy.fetchMusicListCallCount == 1)
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
