//
//  AlbumViewModel.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//

import Combine
import SwiftUI

class AlbumViewModel: ObservableObject {
    @Binding var albumSongs: [Song]
    @Binding var albumDetails: Album?
    @Binding var song: Song

    init(albumSongs: Binding<[Song]>, albumDetails: Binding<Album?>, song: Binding<Song>) {
        self._albumSongs = albumSongs
        self._albumDetails = albumDetails
        self._song = song
    }

    func setupAlbumName() -> String {
        guard let albumDetails = albumDetails else {
            return ""
        }
        return albumDetails.albumName
    }

    func onSelectSong(song: Song) {
        self.song = song
    }
}
