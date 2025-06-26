//
//  AVAudioSession+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 25/06/25.
//

import AVFoundation
import SwiftUI

protocol AVAudioSessionProtocol {
    func setCategory(_ category: AVAudioSession.Category, mode: AVAudioSession.Mode, options: AVAudioSession.CategoryOptions) throws
    func setActive(_ active: Bool, options: AVAudioSession.SetActiveOptions) throws
}

extension AVAudioSession: AVAudioSessionProtocol {}
