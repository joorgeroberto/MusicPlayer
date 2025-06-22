//
//  SongDetailsView.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

struct SongDetailsView: View {
    @ObservedObject var viewModel: SongDetailsViewModel

    init(viewModel: SongDetailsViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            SongDetailsHeader(
                showMoreOptionsBottomSheet: $viewModel.showMoreOptionsBottomSheet
            )

            Spacer()

            Artwork(
                image: viewModel.song.artworkHighQuality,
                width: 200,
                height: 200,
                cornerRadius: 38.91
            )

            Spacer()
            Spacer()

            VStack(alignment: .leading, spacing: 16) {
                SongDetails(song: viewModel.song)

                 PlaybackProgressSlider(
                     currentTime: $viewModel.currentTime,
                     duration: $viewModel.duration, onSeek: { targetTime in
                             viewModel.onSeek(to: targetTime)
                     })

                AudioPlayerButtons(
                    isPlaying: $viewModel.isPlaying,
                    isBackwardButtonAvailable: $viewModel.isBackwardButtonAvailable,
                    isForwardButtonAvailable: $viewModel.isForwardButtonAvailable,
                    onBackward: {
                        viewModel.onBackward()
                    }, onForward: {
                        viewModel.onForward()
                    })


            }
            .padding(.leading, 20)
            .padding(.trailing, 20)

        }
        .navigationBarBackButtonHidden(true)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .padding(.bottom, 25)
        .id(viewModel.song.id)
        .onDisappear {
            viewModel.onDisappear()
        }
        .sheet(isPresented: $viewModel.showMoreOptionsBottomSheet) {
            MoreOptionsBottomSheet(song: viewModel.song, onPressOpenAlbumButton: {
                viewModel.onPressOpenAlbumButton()
            })
        }
        .sheet(isPresented: $viewModel.showAlbumView) {
            AlbumView(viewModel:
                        AlbumViewModel(
                            albumSongs: $viewModel.albumSongs,
                            albumDetails: $viewModel.albumDetails,
                            song: $viewModel.song
                        )
            )
        }
    }
}

#Preview {
    let song = Song.sample()
    SongDetailsView(viewModel: SongDetailsViewModel(song: song))
        .preferredColorScheme(.dark)
}
