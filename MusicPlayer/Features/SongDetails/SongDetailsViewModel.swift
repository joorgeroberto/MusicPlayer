//
//  SongDetailsViewModel.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

class SongDetailsViewModel: ObservableObject {
    @Published var song: Song
    @Published var sliderValue: Double

    init(song: Song, sliderValue: Double = 500) {
        self.song = song
        self.sliderValue = sliderValue
    }
}
