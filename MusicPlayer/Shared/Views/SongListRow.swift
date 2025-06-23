//
//  ListItem.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//
import SwiftUI

struct SongListRow: View {
    @State var song: Song

    var body: some View {
        HStack {
            Artwork(image: song.artworkLowQuality)

            VStack(alignment: .leading, spacing: 4) {
                Text(song.trackName)
                    .font(.custom(.large, .regular))
                    .foregroundColor(Color.Text.primary)

                Text(song.artistName)
                    .font(.custom(.small, .regular))
                    .foregroundColor(Color.Text.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.clear)
        .contentShape(Rectangle())
    }
}

#Preview {
    let song = Song.sample()
    SongListRow(song: song)
        .preferredColorScheme(.dark)
}
