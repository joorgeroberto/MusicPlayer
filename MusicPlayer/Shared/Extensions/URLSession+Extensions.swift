//
//  URLSession+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import SwiftUI

@MainActor
protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
