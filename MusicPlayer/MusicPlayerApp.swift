//
//  MusicPlayerApp.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 18/06/25.
//

import SwiftUI

@main
struct MusicPlayerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            HomeView()
//            let song = Song(
//                trackId: 1147165822,
//                artistId: 546381,
//                trackName: "Run to the Hills (2015 Remaster)",
//                artistName: "Iron Maiden",
//                previewUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/dc/e0/95/dce09593-59e9-7887-4788-b7b0545ab441/mzaf_4833405911961268816.plus.aac.p.m4a",
//                artworkLowQuality:  "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg",
//                trackTimeMilliseconds: 233499
//            )
//            SongDetailsView(viewModel: SongDetailsViewModel(song: song))
                .preferredColorScheme(.dark)
        }
    }
}
