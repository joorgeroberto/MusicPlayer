//
//  ITunesServiceSpy.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 23/06/25.
//

import SwiftUI
import Testing
@testable import MusicPlayer

final class ITunesServiceSpy: ITunesServiceProtocol {
    // MARK: - Track Calls
    private(set) var fetchMusicListCallCount = 0
    private(set) var fetchSongsAndDetailsFromAlbumCallCount = 0

    private(set) var capturedTerm: String?
    private(set) var capturedOffset: Int?
    private(set) var capturedLimit: Int?

    private(set) var capturedAlbumId: String?

    var onFetchMusicListCalled: (() -> Void)?
    var onfetchSongsAndDetailsFromAlbum: (() -> Void)?

    // MARK: - Controlled Results
    var fetchMusicListResult: Result<ITunesSearchResponse, Error> = .failure(URLError(.unknown))
    var fetchSongsAndDetailsFromAlbumResult: Result<ITunesSongsAndDetailsFromAlbumResponse, Error> = .failure(URLError(.unknown))

    // MARK: - ITunesServiceProtocol Methods
    func fetchMusicList(term: String, offset: Int, limit: Int) async throws -> ITunesSearchResponse {
        fetchMusicListCallCount += 1
        capturedTerm = term
        capturedOffset = offset
        capturedLimit = limit

        onFetchMusicListCalled?()

        switch fetchMusicListResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }

    func fetchSongsAndDetailsFromAlbum(withId id: String) async throws -> ITunesSongsAndDetailsFromAlbumResponse {
        fetchSongsAndDetailsFromAlbumCallCount += 1
        capturedAlbumId = id

        onfetchSongsAndDetailsFromAlbum?()

        switch fetchSongsAndDetailsFromAlbumResult {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
