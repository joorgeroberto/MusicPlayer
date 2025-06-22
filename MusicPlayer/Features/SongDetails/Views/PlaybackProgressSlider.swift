//
//  PlaybackProgressSlider.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import AVFoundation
import SwiftUI

struct PlaybackProgressSlider: View {
    @Binding var currentTime: Double
    @Binding var duration: Double
    @Binding var player: AVPlayer?

    var body: some View {
        VStack(spacing: 4) {
            Slider(
                value: $currentTime,
                in: 0...29,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        self.seek(to: currentTime)
                    }
                }
            )
            .onAppear {
                let thumbImage = UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
                UISlider.appearance().setThumbImage(thumbImage, for: .normal)

                let trackHeight: CGFloat = 2

                // ---- Minimum Track (BEFORE thumb) - White ----
                let minSize = CGSize(width: 1, height: trackHeight)
                UIGraphicsBeginImageContextWithOptions(minSize, false, 0.0)
                UIColor.white.setFill()
                UIRectFill(CGRect(origin: .zero, size: minSize))
                let minTrackImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()

                // ---- Maximum Track (AFTER thumb) - Gray ----
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
                Text(currentTime.formatTime())
                    .font(.custom(.medium, .regular))
                    .foregroundColor(Color.Text.darkGray)

                Spacer()

                Text("-" + duration.formatTime())
                    .font(.custom(.medium, .regular))
                    .foregroundColor(Color.Text.darkGray)
            }
        }
    }

    private func seek(to seconds: Double) {
        let targetTime = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: targetTime)
    }
}
