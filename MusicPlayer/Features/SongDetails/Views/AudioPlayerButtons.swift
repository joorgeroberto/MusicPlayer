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

    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Spacer()

            Button {

            } label: {
                Image("ic-backward")
                    .resizable()
                    .frame(width:
                            32, height:
                            32)
                    .foregroundColor(.black)
                    .background(
                        Color.clear
                            .frame(width: 48, height: 48)
                            .cornerRadius(100)
                    )
            }

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

            } label: {
                Image("ic-forward")
                    .resizable()
                    .frame(width:
                            32, height:
                            32)
                    .foregroundColor(.black)
                    .background(
                        Color.clear
                            .frame(width: 48, height: 48)
                            .cornerRadius(100)
                    )
            }
            Spacer()
        }
    }
}
