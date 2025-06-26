//
//  AVPlayerFactorySpy.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 24/06/25.
//

import SwiftUI
@testable import MusicPlayer

class AVPlayerFactorySpy: AVPlayerFactoryProtocol {
    private(set) var callCount = 0
    private(set) var receivedURLs: [String] = []

    var playerToReturn: AVPlayerProtocol?
    var errorToThrow: Error?

    func makePlayer(with url: String) throws -> AVPlayerProtocol? {
        callCount += 1
        receivedURLs.append(url)

        if let error = errorToThrow {
            throw error
        }

        return playerToReturn
    }
}
