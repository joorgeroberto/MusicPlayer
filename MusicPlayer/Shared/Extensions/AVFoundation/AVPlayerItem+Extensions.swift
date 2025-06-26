//
//  AVPlayerItem+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 25/06/25.
//

import AVFoundation
import Combine

protocol AVPlayerItemProtocol {
    var duration: CMTime { get }
    var status: AVPlayerItem.Status { get }
    var preferredForwardBufferDuration: TimeInterval { get set }

    func wrappedPublisher<T>(
        for keyPath: KeyPath<AVPlayerItem, T>,
        options: NSKeyValueObservingOptions
    ) -> AnyPublisher<T, Never> where T: Equatable

}

extension AVPlayerItem: @preconcurrency AVPlayerItemProtocol {
    func wrappedPublisher<T>(
        for keyPath: KeyPath<AVPlayerItem, T>,
        options: NSKeyValueObservingOptions
    ) -> AnyPublisher<T, Never> where T: Equatable {
        self.publisher(for: keyPath, options: options)
            .eraseToAnyPublisher()
    }
}
