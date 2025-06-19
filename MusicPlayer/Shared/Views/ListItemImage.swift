//
//  ListItemImage.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

struct ListItemImage: View {
    @State var image: String

    var body: some View {
        AsyncImage(url: URL(string: image)) { image in
            image
                .resizable()
                .frame(width: 44, height: 44)
                .cornerRadius(8)
        } placeholder: {
            Image("ic-music-note")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(10)
                .background(
                    Color.Background.secondary
                        .frame(width: 44, height: 44)
                        .cornerRadius(8)
                )
        }
    }
}

#Preview {
    let image = "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg"
    ListItemImage(image: image)
}
