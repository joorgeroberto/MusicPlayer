//
//  AVPlayerItemSpy.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 25/06/25.
//

import Combine
import AVFoundation
@testable import MusicPlayer

class AVPlayerItemSpy: AVPlayerItemProtocol {

    var duration: CMTime = CMTime(seconds: 0, preferredTimescale: 600)
    var status: AVPlayerItem.Status = .unknown
    private let statusSubject = PassthroughSubject<AVPlayerItem.Status, Never>()

    var publisherCallCount = 0
    var capturedKeyPath: Any?
    var capturedOptions: NSKeyValueObservingOptions?

    var preferredForwardBufferDuration: TimeInterval = 0

    func wrappedPublisher<T>(
        for keyPath: KeyPath<AVPlayerItem, T>,
        options: NSKeyValueObservingOptions
    ) -> AnyPublisher<T, Never> where T: Equatable {
        publisherCallCount += 1
        capturedKeyPath = keyPath
        capturedOptions = options
        return Just(status as! T).eraseToAnyPublisher()
    }

    func publisherForKeyPath<T: Equatable>(
        _ keyPath: KeyPath<AVPlayerItem, T>,
        options: NSKeyValueObservingOptions
    ) -> AnyPublisher<T, Never> {
        if keyPath == \AVPlayerItem.status {
            // Forçando o tipo de Publisher para o compilador aceitar
            return statusSubject
                .compactMap { $0 as? T }
                .eraseToAnyPublisher()
        }

        fatalError("Unhandled keyPath: \(keyPath)")
    }

    func emitStatus(_ newStatus: AVPlayerItem.Status) {
        status = newStatus
        statusSubject.send(newStatus)
    }
}
