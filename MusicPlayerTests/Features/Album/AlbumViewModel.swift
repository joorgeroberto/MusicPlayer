//
//  AlbumViewModel.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 25/06/25.
//

import SwiftUI
import Testing
@testable import MusicPlayer

@Suite("AlbumViewModel Tests") struct AlbumViewModelTests {

    @Suite("setupAlbumName() Tests") struct setupAlbumNameTests {

        @Test("Shouls returns empty string when albumDetails is not populated.")
        func givenEmptyAlbumDetails_whenSetupAlbumNameIsCalled_thenShouldReturnsEmptyString() {
            // Given
            let expectedAlbumDetails: Album? = nil
            let sut = AlbumViewModel(
                albumSongs: .constant([]),
                albumDetails: .constant(expectedAlbumDetails),
                song: .constant(Song.sample())
            )

            // When
            let result = sut.setupAlbumName()

            // Then
            #expect(result == "")
        }

        @Test("Shouls returns the album name when albumDetails is populated.")
        func givenPopulatedAlbumDetails_whenSetupAlbumNameIsCalled_thenShouldReturnsValidAlbumName() {
            // Given
            let expectedAlbumDetails: Album? = Album.sample()
            let sut = AlbumViewModel(
                albumSongs: .constant([]),
                albumDetails: .constant(expectedAlbumDetails),
                song: .constant(Song.sample())
            )

            // When
            let result = sut.setupAlbumName()

            // Then
            #expect(result == expectedAlbumDetails?.albumName)
        }
    }

    @Suite("onSelectSong() Tests") struct onSelectSongTests {
        @Test func given_when_then() {
            var songState: Song = Song.sample(
                trackId: 1,
                trackName: "Powerslave",
                artistName: "Iron Maiden"
            )
            let sut = AlbumViewModel(
                albumSongs: .constant([]),
                albumDetails: .constant(nil),
                song: Binding(
                    get: { songState },
                    set: { songState = $0 }
                )
            )
            let expectedSong: Song = Song.sample(
                trackId: 2,
                trackName: "One",
                artistName: "Metallica"
            )

            // When
            sut.onSelectSong(song: expectedSong)

            // Then
            #expect(sut.song == expectedSong)
        }
    }
}
