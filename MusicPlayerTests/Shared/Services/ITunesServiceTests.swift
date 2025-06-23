//
//  ITunesServiceTests.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import SwiftUI
import Testing
@testable import MusicPlayer

@Suite("ITunesService Tests") struct ITunesServiceTests {
    @Suite("fetchMusicList() Tests") struct fetchMusicList {

        @Suite struct Success {
            private var networkManagerSpy = NetworkManagerSpy()
            var expectedError: URLError? = nil
            let baseURL = "http://example.com"
            let expectedURL = "http://example.com/search?term=Iron%20Maiden&media=music&offset=0&limit=50"
            var response: ITunesSearchResponse?

            @Test mutating func fetch_GivenCorrectUrl_WhenNetworkManagerFetchReturnsCorrectResponse_ThenfetchMusicListShouldReceiveCorrectResponseWithoutErrors() async {
                // Given
                let resultToBeReturned = ITunesSearchResponse.sample()
                networkManagerSpy.resultToBeReturned = resultToBeReturned
                let sut = ITunesService(networkManager: networkManagerSpy, baseURL: baseURL)

                // When
                do {
                    response = try await sut.fetchMusicList(term: Song.sample().artistName)
                } catch {
                    expectedError = error as? URLError
                }

                // Then
                #expect(expectedError == nil)
                #expect(networkManagerSpy.fetchCallCount == 1)
                #expect(networkManagerSpy.capturedURL?.absoluteString == expectedURL)
                #expect(response?.resultCount == resultToBeReturned.resultCount)
                #expect(response?.results == resultToBeReturned.results)
            }
        }
    }

    @Suite struct Failure {
        private var networkManagerSpy = NetworkManagerSpy()
        var expectedError: URLError? = nil
        var errorToThrow: URLError? = nil
        let baseURL = "http://example.com"
        let expectedURL = "http://example.com/search?term=Iron%20Maiden&media=music&offset=0&limit=50"

        @Test mutating func fetch_GivenCorrectUrl_WhenNetworkManagerFetchReturnsAnError_ThenfetchMusicListShouldReceiveError() async {
            // Given

            errorToThrow = URLError(.badServerResponse)
            networkManagerSpy.errorToThrow = errorToThrow
            networkManagerSpy.resultToBeReturned = ITunesSearchResponse.sample()
            let sut = ITunesService(networkManager: networkManagerSpy, baseURL: baseURL)

            // When
            do {
                _ = try await sut.fetchMusicList(term: Song.sample().artistName)
            } catch {
                expectedError = error as? URLError
            }

            // Then
            #expect(expectedError == errorToThrow)
            #expect(networkManagerSpy.fetchCallCount == 1)
            #expect(networkManagerSpy.capturedURL?.absoluteString == expectedURL)
        }
    }
}

@Suite("fetchSongsAndDetailsFromAlbum() Tests") struct fetchSongsAndDetailsFromAlbum {

    @Suite struct Success {
        private var networkManagerSpy = NetworkManagerSpy()
        var expectedError: URLError? = nil
        let baseURL = "http://example.com"
        let expectedURL = "http://example.com/lookup?id=1147165685&media=music&entity=song"
        var response: ITunesSongsAndDetailsFromAlbumResponse?

        @Test mutating func fetch_GivenCorrectUrl_WhenNetworkManagerFetchReturnsCorrectResponse_ThenfetchSongsAndDetailsFromAlbumShouldReceiveCorrectResponseWithoutErrors() async {
            // Given
            let resultToBeReturned = ITunesSongsAndDetailsFromAlbumResponse.sample()
            networkManagerSpy.resultToBeReturned = resultToBeReturned
            let sut = ITunesService(networkManager: networkManagerSpy, baseURL: baseURL)

            // When
            do {
                response = try await sut.fetchSongsAndDetailsFromAlbum(withId: String(Song.sample().albumId ?? 1))
            } catch {
                expectedError = error as? URLError
            }

            // Then
            #expect(expectedError == nil)
            #expect(networkManagerSpy.fetchCallCount == 1)
            #expect(networkManagerSpy.capturedURL?.absoluteString == expectedURL)
            #expect(response?.resultCount == resultToBeReturned.resultCount)
            #expect(response?.results == resultToBeReturned.results)
        }
    }


    @Suite struct Failure {
        private var networkManagerSpy = NetworkManagerSpy()
        var expectedError: URLError? = nil
        var errorToThrow: URLError? = nil
        let baseURL = "http://example.com"
        let expectedURL = "http://example.com/lookup?id=1147165685&media=music&entity=song"

        @Test mutating func fetch_GivenCorrectUrl_WhenNetworkManagerFetchReturnsAnError_ThenfetchSongsAndDetailsFromAlbumShouldReceiveError() async {
            // Given

            errorToThrow = URLError(.badServerResponse)
            networkManagerSpy.errorToThrow = errorToThrow
            networkManagerSpy.resultToBeReturned = ITunesSongsAndDetailsFromAlbumResponse.sample()
            let sut = ITunesService(networkManager: networkManagerSpy, baseURL: baseURL)

            // When
            do {
                _ = try await sut.fetchSongsAndDetailsFromAlbum(withId: String(Song.sample().albumId ?? 1))
            } catch {
                expectedError = error as? URLError
            }

            // Then
            #expect(expectedError == errorToThrow)
            #expect(networkManagerSpy.fetchCallCount == 1)
            #expect(networkManagerSpy.capturedURL?.absoluteString == expectedURL)
        }
    }
}

