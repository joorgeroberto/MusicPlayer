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

                AudioPlayerButtons(
                    isPlaying: $viewModel.isPlaying
                )
            }
            .padding(.leading, 20)
            .padding(.trailing, 20)

        }
        .navigationBarBackButtonHidden(true)
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .padding(.bottom, 25)
        .onDisappear {
            viewModel.onDisappear()
        }
    }

    
    var CustomSlider: some View {
        VStack(spacing: 4) {
            Slider(
                value: $viewModel.currentTime,
                in: 0...29,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        viewModel.seek(to: viewModel.currentTime)
                    }
                }
            )
            .onAppear {
                let thumbImage = UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                UISlider.appearance().setThumbImage(thumbImage, for: .normal)

                let trackHeight: CGFloat = 2

                // ---- Minimum Track (ANTES da thumb) - Branco ----
                let minSize = CGSize(width: 1, height: trackHeight)
                UIGraphicsBeginImageContextWithOptions(minSize, false, 0.0)
                UIColor.white.setFill()
                UIRectFill(CGRect(origin: .zero, size: minSize))
                let minTrackImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                // ---- Maximum Track (DEPOIS da thumb) - Cinza ----
                UIGraphicsBeginImageContextWithOptions(minSize, false, 0.0)
                UIColor.gray.setFill()  // Cor cinza
                UIRectFill(CGRect(origin: .zero, size: minSize))
                let maxTrackImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                if let minImage = minTrackImage, let maxImage = maxTrackImage {
                    UISlider.appearance().setMinimumTrackImage(minImage.resizableImage(withCapInsets: .zero), for: .normal)
                    UISlider.appearance().setMaximumTrackImage(maxImage.resizableImage(withCapInsets: .zero), for: .normal)
                }
            }

            HStack {
                Text(viewModel.currentTime.formatTime())
                    .font(.medium)
                    .foregroundColor(Color.Text.darkGray)

                Spacer()

                Text("-" + viewModel.duration.formatTime())
                    .font(.medium)
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
        previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/dc/e0/95/dce09593-59e9-7887-4788-b7b0545ab441/mzaf_4833405911961268816.plus.aac.p.m4a",
        artworkLowQuality:  "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg",
        trackTimeMilliseconds: 233499
    )
    SongDetailsView(viewModel: SongDetailsViewModel(song: song))
        .preferredColorScheme(.dark)
}
