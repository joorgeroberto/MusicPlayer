//
//  AVPlayerSpy.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 24/06/25.
//

import SwiftUI
import AVFoundation
@testable import MusicPlayer

class AVPlayerSpy: AVPlayerProtocol {
    private(set) var playCallCount = 0
    private(set) var pauseCallCount = 0
    private(set) var seekCallCount = 0
    private(set) var removeTimeObserverCallCount = 0
    private(set) var capturedSeekTime = CMTime(seconds: 0, preferredTimescale: 600)
    private(set) var removedTimeObservers: [Any] = []
    private(set) var addedTimeObservers: [(interval: CMTime, block: (CMTime) -> Void)] = []

    var automaticallyWaitsToMinimizeStalling = false
    var currentItem: AVPlayerItem? = nil

    func play() {
        playCallCount += 1
    }

    func pause() {
        pauseCallCount += 1
    }

    func seek(to time: CMTime) {
        capturedSeekTime = time
        seekCallCount += 1
    }

    func addPeriodicTimeObserver(forInterval interval: CMTime, queue: DispatchQueue?, using block: @escaping (CMTime) -> Void) -> Any {
        addedTimeObservers.append((interval, block))
        return "SampleObserver" as Any
    }

    func removeTimeObserver(_ observer: Any) {
        removeTimeObserverCallCount += 1
        removedTimeObservers.append(observer)
    }
}
