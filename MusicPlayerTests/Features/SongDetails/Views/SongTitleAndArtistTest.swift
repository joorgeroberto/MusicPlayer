//
//  SongTitleAndArtistTest.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import MusicPlayer

final class SongTitleAndArtistTests: XCTestCase {

    func testView_DisplaysTrackNameAndArtistName() throws {
        // Given
        let song = Song.sample()
        let view = SongTitleAndArtist(song: song)

        // When
        let vStack = try view.inspect().implicitAnyView().vStack()

        let trackNameText = try vStack.text(0).string()
        let artistNameText = try vStack.text(1).string()

        // Then
        XCTAssertEqual(trackNameText, Song.sample().trackName)
        XCTAssertEqual(artistNameText, Song.sample().artistName)
    }
}
