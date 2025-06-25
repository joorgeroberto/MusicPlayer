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

    func makePlayer(with url: String) -> AVPlayerProtocol? {
        callCount += 1
        receivedURLs.append(url)
        return playerToReturn
    }
}
