//
//  ListItem.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//
import SwiftUI

struct ListItem: View {
    @State var song: Song

    var body: some View {
        HStack {
            ListItemImage(image: song.artworkUrl100)

            VStack(alignment: .leading, spacing: 4) {
                Text(song.trackName)
                    .font(.large)
                    .foregroundColor(Color.Text.primary)

                Text(song.artistName)
                    .font(.small)
                    .foregroundColor(Color.Text.secondary)
            }
        }
    }
}

#Preview {
    let song = Song(
        trackId: 1147165822,
        artistId: 546381,
        trackName: "Run to the Hills (2015 Remaster)",
        artistName: "Iron Maiden",
        artworkUrl100:  "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg"
    )
    ListItem(song: song)
}
