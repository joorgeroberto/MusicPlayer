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
    let onSeek: (Double) -> Void

    var body: some View {
        VStack(spacing: 4) {
            Slider(
                value: $currentTime,
                in: 0...29,
                onEditingChanged: { isEditing in
                    if !isEditing {
                        onSeek(currentTime)
                    }
                }
            )
            .onAppear {
                configureSliderThumb()
                configureSliderTrackAppearance()
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

    private func configureSliderThumb() {
        let thumbImage = UIImage(systemName: "circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
    }

    private func configureSliderTrackAppearance() {
        let trackHeight: CGFloat = 2
        let minSize = CGSize(width: 1, height: trackHeight)

        let minTrackImage = generateTrackImage(color: .white, size: minSize)
        let maxTrackImage = generateTrackImage(color: .gray, size: minSize)

        if let minImage = minTrackImage, let maxImage = maxTrackImage {
            UISlider.appearance().setMinimumTrackImage(minImage.resizableImage(withCapInsets: .zero), for: .normal)
            UISlider.appearance().setMaximumTrackImage(maxImage.resizableImage(withCapInsets: .zero), for: .normal)
        }
    }

    private func generateTrackImage(color: UIColor, size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

#Preview {
    PlaybackProgressSlider(currentTime: .constant(0), duration: .constant(29), onSeek: {_ in })
        .preferredColorScheme(.dark)
}
