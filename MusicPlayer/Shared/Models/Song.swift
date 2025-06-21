//
//  Song.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

struct Song: Codable, Identifiable, Equatable, Hashable {
    let trackId: Int
    let artistId: Int
    let trackName: String
    let artistName: String
    let collectionName: String
    let previewUrl: String
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
        case collectionName
        case previewUrl
        case artworkLowQuality = "artworkUrl100"
        case trackTimeMilliseconds = "trackTimeMillis"
    }
}
