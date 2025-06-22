//
//  AudioPlayerButtons.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 20/06/25.
//

import SwiftUI

import AVFoundation

struct AudioPlayerButtons: View {
    @Binding var isPlaying: Bool
    @Binding var isBackwardButtonAvailable: Bool
    @Binding var isForwardButtonAvailable: Bool
    let onBackward: () -> Void
    let onForward: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()

            Button {
                onBackward()
            } label: {
                Image("ic-backward")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
                    .background(
                        Color.clear
                            .frame(width: 48, height: 48)
                            .cornerRadius(100)
                    )
                    .opacity(isBackwardButtonAvailable ? 1 : 0.5)
            }
            .disabled(!isBackwardButtonAvailable)

            Button {
                isPlaying.toggle()
            } label: {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill" )
                    .resizable()
                    .frame(width:
                            18.67, height:
                            21.15)
                    .foregroundColor(.black)
                    .background(
                        Color.white
                            .frame(width: 64, height: 64)
                            .cornerRadius(100)
                    )
            }
            .frame(width: 64, height: 64)

            Button {
                onForward()
            } label: {
                Image("ic-forward")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.black)
                    .background(
                        Color.clear
                            .frame(width: 48, height: 48)
                            .cornerRadius(100)
                    )
                    .opacity(isForwardButtonAvailable ? 1 : 0.5)
            }

            .disabled(!isForwardButtonAvailable)
            Spacer()
        }
    }
}

#Preview {
    AudioPlayerButtons(
        isPlaying: .constant(false),
        isBackwardButtonAvailable: .constant(true),
        isForwardButtonAvailable: .constant(true),
        onBackward: {},
        onForward: {}
    )
        .preferredColorScheme(.dark)
}
