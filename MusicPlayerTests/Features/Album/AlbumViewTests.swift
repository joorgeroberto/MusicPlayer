//
//  AlbumViewTests.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import MusicPlayer

final class AlbumViewTests: XCTestCase {

    func testAlbumNameIsDisplayed() throws {
        // Given
        let viewModel = AlbumViewModel(
            albumSongs: .constant([Song.sample()]),
            albumDetails: .constant(Album.sample()),
            song: .constant(Song.sample())
        )
        let sut = AlbumView(viewModel: viewModel)

        // When
        let text = try sut.inspect().find(ViewType.Text.self).string()

        // Then
        XCTAssertEqual(text, Album.sample().albumName)
    }

    func testListHasCorrectNumberOfSongs() throws {
        // Given
        let songs = [Song.sample(trackName: "Song 1"), Song.sample(trackName: "Song 2")]
        let viewModel = AlbumViewModel(
            albumSongs: .constant(songs),
            albumDetails: .constant(Album.sample()),
            song: .constant(Song.sample())
        )
        let sut = AlbumView(viewModel: viewModel)

        // When
        let list = try sut.inspect().find(ViewType.List.self)
        let forEach = try list.forEach(0)

        // Then
        XCTAssertEqual(forEach.count, songs.count)
    }

//    func testSongButtonTapCallsOnSelectSong() throws {
//        // Given
//        var selectedSong: Song? = nil
//        let songs = [Song.sample(trackName: "Song 1")]
//        let viewModel = AlbumViewModel(
//            albumSongs: .constant(songs),
//            albumDetails: .constant(Album.sample()),
//            song: .constant(Song.sample())
//        )
//
////        viewModel.onSelectSong = { song in
////            selectedSong = song
////        }
//        viewModel.onSelectSong(song: songs[0])
//
//        let sut = AlbumView(viewModel: viewModel)
//
//        // When
//        let list = try sut.inspect().find(ViewType.List.self)
//        let firstRowButton = try list.forEach(0).button(0)
//        try firstRowButton.tap()
//
//        // Then
//        XCTAssertEqual(selectedSong, songs[0])
//    }

    func testShowsProgressViewWhenAlbumSongsIsEmpty() throws {
        // Given
        let viewModel = AlbumViewModel(
            albumSongs: .constant([]),  // lista vazia
            albumDetails: .constant(Album.sample()),
            song: .constant(Song.sample())
        )
        let sut = AlbumView(viewModel: viewModel)

        // When
        let progressView = try sut.inspect().find(ViewType.ProgressView.self)

        // Then
        XCTAssertNotNil(progressView)
    }
}

