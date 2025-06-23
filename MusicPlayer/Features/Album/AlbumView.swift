//
//  AlbumView.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//

import SwiftUI

struct AlbumView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AlbumViewModel

    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            VStack {
                Text(viewModel.setupAlbumName())
                    .font(.custom(.large, .bold))
                    .foregroundColor(Color.Text.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 8)

                    List(viewModel.albumSongs, id: \.trackId) { song in
                        Button {
                            viewModel.onSelectSong(song: song)
                            dismiss()
                        } label: {
                            SongListRow(song: song)
                                .background(Color.clear)
                                .contentShape(Rectangle())
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets())

                    }
                    .listStyle(.plain)
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)

            }
            .padding(.top, 25)
            .padding(.bottom, 16)
            .padding(.horizontal, 8)

            if viewModel.$albumSongs.isEmpty {
                Color.Background.primary
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }

        }
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    AlbumView(
        viewModel: AlbumViewModel(
            albumSongs: .constant([Song.sample(),
                                   Song.sample()]
                                 ),
            albumDetails: .constant(Album.sample(albumName: "The Number of the Beast (2015 Remaster)")),
            song: .constant(Song.sample())
        )
    )
        .preferredColorScheme(.dark)
}
