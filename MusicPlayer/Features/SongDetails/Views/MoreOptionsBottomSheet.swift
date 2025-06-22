//
//  MoreOptionsBottomSheet.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//

import SwiftUI

struct MoreOptionsBottomSheet: View {
    @State var song: Song
    let onPressOpenAlbumButton: () -> Void

    var body: some View {
        VStack(alignment: .center, spacing: 42) {
            VStack(alignment: .center, spacing: 14) {
                Text(song.albumName)
                    .font(.custom(.xLarge, .semibold))
                    .foregroundColor(Color.Text.primary)
                    .multilineTextAlignment(.center)
                Text(song.artistName)
                    .font(.custom(.medium, .regular))
                    .foregroundColor(Color.Text.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)

            Button(action: {
                onPressOpenAlbumButton()
            }, label: {
                HStack(spacing: 16) {
                    Image("ic-playlist")
                        .frame(width: 24, height: 24)
                    Text("Open album")
                        .font(.custom(.large, .regular))
                        .foregroundColor(Color.Text.primary)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            })
            .padding(.horizontal, 32)

        }
        .padding(.horizontal, 0)
        .frame(maxWidth: .infinity, maxHeight: 300)
        .presentationDetents([.height(187)])
        .presentationDragIndicator(.visible)
    }
}

#Preview("Long Title"){
    let song = Song.sample()
    MoreOptionsBottomSheet(song: song, onPressOpenAlbumButton: {})
        .preferredColorScheme(.dark)
}

#Preview("Short Title") {
    let song = Song.sample(albumName: "Born to Die")
    MoreOptionsBottomSheet(song: song, onPressOpenAlbumButton: {})
        .preferredColorScheme(.dark)
}

