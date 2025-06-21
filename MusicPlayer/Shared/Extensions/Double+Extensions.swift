//
//  Double+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 20/06/25.
//

extension Double {
    func toMinutesAndSeconds() -> String {
        let totalSeconds = Int(self / 1000)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    func formatTime() -> String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
