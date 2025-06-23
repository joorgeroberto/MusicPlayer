//
//  NetworkManagerTests.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import SwiftUI
import Testing
@testable import MusicPlayer

@Suite("Network Manager Tests") struct NetworkManagerTests {
    @Suite("fetch() Tests") struct fetch {
        @MainActor
        @Suite struct Success {
            let url = URL(string: "http://example.com")!
            let expectedSong = Song.sample()
            private lazy var dataToBeReturned: Data = {
                try! JSONEncoder().encode(expectedSong)
            }()
            private lazy var responseToBeReturned: HTTPURLResponse = {
                HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            }()
            private var urlSessionSpy = URLSessionSpy()

            @Test mutating func fetch_GivenCorrectUrl_WhenNetworkManagerIsCalled_ThenShouldReceiveDataAndResponse() async throws {
                // Given
                urlSessionSpy.dataToBeReturned = dataToBeReturned
                urlSessionSpy.responseToBeReturned = responseToBeReturned
                urlSessionSpy.errorToThrow = nil
                let sut = NetworkManager(urlSession: urlSessionSpy)

                // When
                let data: Song? = try? await sut.fetch(url: url)

                // Then
                #expect(data?.artistName == Song.sample().artistName)
            }
        }

        @MainActor
        @Suite struct Failure {
            let url = URL(string: "http://example.com")!
            let expectedSong = Song.sample()
            private lazy var dataToBeReturned: Data = {
                try! JSONEncoder().encode(expectedSong)
            }()
            private lazy var responseToBeReturned: HTTPURLResponse = {
                HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            }()
            private var errorToBeReturned: Error?
            private var urlSessionSpy = URLSessionSpy()

            @Test mutating func fetch_GivenCorrectUrl_WhenUrlSessionReturnsError_ThenShouldReturnsError() async throws {
                // Given
                let errorToBeReturned = URLError(.networkConnectionLost)
                urlSessionSpy.errorToThrow = errorToBeReturned
                let sut = NetworkManager(urlSession: urlSessionSpy)
                var expectedError: URLError? = nil
                var data: Song?

                // When
                do {
                    data = try await sut.fetch(url: url)
                } catch {
                    expectedError = error as? URLError
                }

                // Then
                #expect(data?.artistName == nil)
                #expect(expectedError == errorToBeReturned)
            }

            @Test mutating func fetch_GivenCorrectUrl_WhenResponseReturnsError_ThenShouldReturnsBadServerResponseError() async {

                // Given
                responseToBeReturned = HTTPURLResponse(url: url, statusCode: 500, httpVersion: nil, headerFields: nil)!
                urlSessionSpy.dataToBeReturned = dataToBeReturned
                urlSessionSpy.responseToBeReturned = responseToBeReturned
                let sut = NetworkManager(urlSession: urlSessionSpy)
                var expectedError: URLError? = nil
                var data: Song?

                // When
                do {
                    data = try await sut.fetch(url: url)
                } catch {
                    expectedError = error as? URLError
                }

                // Then
                #expect(data?.artistName == nil)
                #expect(expectedError == URLError(.badServerResponse))
            }

            @Test mutating func fetch_GivenCorrectUrl_WhenDataReturnsError_ThenShouldReturnsCannotDecodeContentDataError() async {
                // Given
                urlSessionSpy.dataToBeReturned = "".data(using: .utf8)!
                urlSessionSpy.responseToBeReturned = responseToBeReturned
                let sut = NetworkManager(urlSession: urlSessionSpy)
                var expectedError: URLError? = nil
                var data: Song?

                // When
                do {
                    data = try await sut.fetch(url: url)
                } catch {
                    expectedError = error as? URLError
                }

                // Then
                #expect(data?.artistName == nil)
                #expect(expectedError == URLError(.cannotDecodeContentData))
            }
        }
    }
}
