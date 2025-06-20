//
//  TrackDetails.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 20/06/25.
//

import SwiftUI

struct SongDetails: View {
    @State var song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(song.trackName)
                .font(.xLarge)
                .foregroundColor(Color.Text.primary)

            Text(song.artistName)
                .font(.medium)
                .foregroundColor(Color.Text.secondary)
        }
    }

}
