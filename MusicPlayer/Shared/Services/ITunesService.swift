//
//  ITunesService.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

protocol ITunesServiceProtocol {
    func fetchMusicList(term: String, offset: Int, limit: Int) async throws -> ITunesSearchResponse
}

final class ITunesService: ITunesServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let baseURL = "https://itunes.apple.com"

    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
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
}
