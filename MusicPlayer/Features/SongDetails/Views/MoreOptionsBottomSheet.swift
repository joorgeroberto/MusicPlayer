//
//  MoreOptionsBottomSheet.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//

import SwiftUI

struct MoreOptionsBottomSheet: View {
    @State var song: Song

    var body: some View {
        VStack(spacing: 42) {
            VStack(alignment: .center, spacing: 14) {
                Text(song.collectionName)
                    .font(.custom(.xLarge, .semibold))
                    .foregroundColor(Color.Text.primary)
                    .multilineTextAlignment(.center)
                Text(song.artistName)
                    .font(.custom(.medium, .regular))
                    .foregroundColor(Color.Text.secondary)
                    .multilineTextAlignment(.center) 
            }

            Button(action: {

            }, label: {
                HStack(spacing: 16) {
                    Image("ic-playlist")
                        .frame(width: 24, height: 24)
                    Text("Open album")
                        .font(.custom(.large, .regular))
                        .foregroundColor(Color.Text.primary)
                }
            })

        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: 300)
        .presentationDetents([.height(200)])
        .presentationDragIndicator(.visible)

    }
}

#Preview {
    let song = Song(
        trackId: 1147165822,
        artistId: 546381,
        trackName: "Run to the Hills (2015 Remaster)",
        artistName: "Iron Maiden",
        collectionName: "The Number of the Beast (2015 Remaster)",
        previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/dc/e0/95/dce09593-59e9-7887-4788-b7b0545ab441/mzaf_4833405911961268816.plus.aac.p.m4a",
        artworkLowQuality:  "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg",
        trackTimeMilliseconds: 233499
    )
    MoreOptionsBottomSheet(song: song)
        .preferredColorScheme(.dark)
}
