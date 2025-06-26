//
//  SongTitleAndArtist.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 20/06/25.
//

import SwiftUI

struct SongTitleAndArtist: View {
    @State var song: Song

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(song.trackName)
                .font(.custom(.xxLarge, .regular))
                .foregroundColor(Color.Text.primary)

            Text(song.artistName)
                .font(.custom(.medium, .regular))
                .foregroundColor(Color.Text.secondary)
        }
    }

}
