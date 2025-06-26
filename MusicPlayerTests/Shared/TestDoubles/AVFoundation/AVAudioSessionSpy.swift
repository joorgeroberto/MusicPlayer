//
//  AVAudioSessionSpy.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 25/06/25.
//


import AVFoundation
@testable import MusicPlayer

final class AVAudioSessionSpy: AVAudioSessionProtocol {
    private(set) var setCategoryCallCount = 0
    private(set) var setActiveCallCount = 0

    private(set) var capturedCategory: AVAudioSession.Category?
    private(set) var capturedMode: AVAudioSession.Mode?
    private(set) var capturedSetCategoryOptions: AVAudioSession.CategoryOptions?
    private(set) var capturedSetActiveOptions: AVAudioSession.SetActiveOptions?
    private(set) var capturedActiveState: Bool?

    var setCategoryErrorToThrow: Error?
    var setActiveErrorToThrow: Error?

    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions = []) throws {
        setCategoryCallCount += 1
        capturedCategory = category
        capturedMode = mode
        capturedSetCategoryOptions = options

        if let error = setCategoryErrorToThrow {
            throw error
        }
    }

    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions = []) throws {
        setActiveCallCount += 1
        capturedActiveState = active
        capturedSetActiveOptions = options

        if let error = setActiveErrorToThrow {
            throw error
        }
    }
}
