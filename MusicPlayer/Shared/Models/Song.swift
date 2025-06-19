//
//  Song.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

struct ITunesSearchResponse: Codable {
    let resultCount: Int
    let results: [Song]
}

struct Song: Codable, Identifiable, Equatable {
    let trackId: Int
    let artistId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String

    var id: Int { trackId }
}
