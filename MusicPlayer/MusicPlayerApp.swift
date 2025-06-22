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
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}
