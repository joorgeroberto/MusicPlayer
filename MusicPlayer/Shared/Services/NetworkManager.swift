//
//  NetworkService.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

protocol NetworkManagerProtocol {
    func fetch<T: Decodable>(url: URL) async throws -> T
}

class NetworkManager: NetworkManagerProtocol {
    private var urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetch<T: Decodable>(url: URL) async throws -> T {
        let (data, response): (Data, URLResponse)

        do {
            (data, response) = try await urlSession.data(from: url)
        } catch {
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw URLError(.cannotDecodeContentData)
        }
    }
}
