//
//  ITunesService.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

@MainActor
protocol ITunesServiceProtocol {
    func fetchMusicList(term: String, offset: Int, limit: Int) async throws -> ITunesSearchResponse
    func fetchSongsAndDetailsFromAlbum(withId id: String) async throws -> ITunesSongsAndDetailsFromAlbumResponse
}

final class ITunesService: ITunesServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseURL: String

    init(
        networkManager: NetworkManagerProtocol = NetworkManager(),
        baseURL: String = "https://itunes.apple.com"
    ) {
        self.networkManager = networkManager
        self.baseURL = baseURL
    }

    func fetchMusicList(term: String, offset: Int = 0, limit: Int = 50) async throws -> ITunesSearchResponse {
        let queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]

        var urlComponents = URLComponents(string: baseURL + "/search")!
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        return try await networkManager.fetch(url: url)
    }

    func fetchSongsAndDetailsFromAlbum(withId id: String) async throws -> ITunesSongsAndDetailsFromAlbumResponse {
        let queryItems = [
            URLQueryItem(name: "id", value: id),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song")
        ]

        var urlComponents = URLComponents(string: baseURL + "/lookup")!
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        return try await networkManager.fetch(url: url)
    }
}
