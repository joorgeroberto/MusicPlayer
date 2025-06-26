//
//  AVPlayerFactory.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 24/06/25.
//

import SwiftUI
import AVFoundation

protocol AVPlayerFactoryProtocol {
    func makePlayer(with url: String) throws -> AVPlayerProtocol?
}

@MainActor
class AVPlayerFactory: @preconcurrency AVPlayerFactoryProtocol {
    func makePlayer(with url: String) throws -> AVPlayerProtocol? {
        guard let url = URL(string: url) else {
            throw CommonsErrors.invalidURL
        }
        let player = AVPlayer(url: url)
        player.automaticallyWaitsToMinimizeStalling = false
        player.currentItem?.preferredForwardBufferDuration = 0
        return player
    }
}
