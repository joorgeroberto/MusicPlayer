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
    var artworkLowQuality: String
    var artworkHighQuality: String {
        artworkLowQuality.replacingImageSize(to: 600)
    }
    let trackTimeMilliseconds: Double
    var trackTimeMinutesAndSeconds: String {
        trackTimeMilliseconds.toMinutesAndSeconds()
    }

    var id: Int { trackId }

    private enum CodingKeys: String, CodingKey {
        case trackId
        case artistId
        case trackName
        case artistName
        case artworkLowQuality = "artworkUrl100"
        case trackTimeMilliseconds = "trackTimeMillis"
    }
}
