//
//  ListItemImage.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

struct ListItemImage: View {
    @State var image: String
    @State var width: CGFloat = 44
    @State var height: CGFloat = 44

    var body: some View {
        AsyncImage(url: URL(string: image)) { image in
            image
                .resizable()
                .frame(width: width, height: height)
                .cornerRadius(8)
        } placeholder: {
            Image("ic-music-note")
                .resizable()
            // deixar altura e largura em 54.4%
                .frame(width: width, height: 24)
                .padding(10)
                .background(
                    Color.Background.secondary
                        .frame(width: width, height: height)
                        .cornerRadius(8)
                )
        }
    }
}

#Preview {
//    let image = "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg"
    let image = ""
    ListItemImage(image: image, width: <#T##CGFloat#>)
        .preferredColorScheme(.dark)
}
