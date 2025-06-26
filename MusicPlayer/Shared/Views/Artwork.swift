//
//  Artwork.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

struct Artwork: View {
    @State var image: String
    @State var width: CGFloat = 44
    @State var height: CGFloat = 44
    @State var cornerRadius: CGFloat = 8

    var body: some View {
        AsyncImage(url: URL(string: image)) { image in
            image
                .resizable()
                .frame(width: width, height: height)
                .cornerRadius(cornerRadius)
        } placeholder: {
            Image("ic-music-note")
                .resizable()
                .frame(width: width * 0.544, height: width * 0.544)
                .padding(10)
                .background(
                    Color.Background.secondary
                        .frame(width: width, height: height)
                        .cornerRadius(cornerRadius)
                )
        }
    }
}

#Preview {
    let image = "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/600x600bb.jpg"
    Artwork(image: image, width: 44, height: 44)
        .preferredColorScheme(.dark)
}
