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
            SongDetailsHeader()

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

                CustomSlider

                AudioPlayerButtons()
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)

        }
        .navigationBarBackButtonHidden(true)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .padding(.bottom, 25)
    }

    
    var CustomSlider: some View {
        VStack(spacing: 4) {
            Slider(value: $viewModel.sliderValue, in: 0...Double(viewModel.song.trackTimeMilliseconds))

            HStack {
                Text("0.00")
                    .font(.medium)
                    .foregroundColor(Color.Text.darkGray)

                Spacer()

                Text("-" + viewModel.song.trackTimeMinutesAndSeconds).font(.medium)
                    .foregroundColor(Color.Text.darkGray)
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
        artworkLowQuality:  "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg",
        trackTimeMilliseconds: 233499
    )
    SongDetailsView(viewModel: SongDetailsViewModel(song: song))
        .preferredColorScheme(.dark)
}
