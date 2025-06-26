//
//  AVPlayer+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 24/06/25.
//

import AVFoundation
import SwiftUI

protocol AVPlayerProtocol {
    func play()
    func pause()
    func seek(to time: CMTime)
    func addPeriodicTimeObserver(
        forInterval interval: CMTime,
        queue: dispatch_queue_t?,
        using block: @escaping @Sendable (CMTime) -> Void
    ) -> Any
    func removeTimeObserver(_ observer: Any)

    var currentItem: AVPlayerItem? { get }
    var automaticallyWaitsToMinimizeStalling: Bool { get set }
}

extension AVPlayer: AVPlayerProtocol {}

enum CommonsErrors: Error {
    case generic
    case invalidURL
}
