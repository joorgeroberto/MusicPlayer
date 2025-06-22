//
//  Song.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

protocol ArtworkUpgradable {
    var artworkLowQuality: String { get }
}

extension ArtworkUpgradable {
    var artworkHighQuality: String {
        return setupArtworkHighQuality(size: 600)
    }

    func setupArtworkHighQuality(size: Int = 600) -> String {
        return artworkLowQuality.replacingOccurrences(
            of: #"/\d+x\d+bb\.jpg"#,
            with: "/\(size)x\(size)bb.jpg",
            options: .regularExpression
        )
    }
}

struct Song: Codable, Identifiable, Equatable, Hashable, ArtworkUpgradable {
    let trackId: Int
    let artistId: Int
    let trackName: String
    let trackNumber: Int
    let artistName: String
    let albumId: Int
    let albumName: String
    let previewUrl: String
    var artworkLowQuality: String
    let trackTimeMilliseconds: Double
    var trackTimeMinutesAndSeconds: String {
        trackTimeMilliseconds.toMinutesAndSeconds()
    }

    var id: Int { trackId }

    private enum CodingKeys: String, CodingKey {
        case trackId
        case artistId
        case trackName
        case trackNumber
        case artistName
        case albumId = "collectionId"
        case albumName = "collectionName"
        case previewUrl
        case artworkLowQuality = "artworkUrl100"
        case trackTimeMilliseconds = "trackTimeMillis"
    }
}

extension Song {
    static func sample(
        trackId: Int = 1147165822,
        artistId: Int = 546381,
        trackName: String = "Run to the Hills (2015 Remaster)",
        artistName: String = "Iron Maiden",
        albumId: Int = 1147165685,
        albumName: String = "The Number of the Beast (2015 Remaster)",
        previewUrl: String = "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview125/v4/dc/e0/95/dce09593-59e9-7887-4788-b7b0545ab441/mzaf_4833405911961268816.plus.aac.p.m4a",
        artworkLowQuality: String = "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg",
        trackTimeMilliseconds: Double = 233499
    ) -> Self {
        .init(
            trackId: trackId,
            artistId: artistId,
            trackName: trackName,
            trackNumber: 6,
            artistName: artistName,
            albumId: albumId,
            albumName: albumName,
            previewUrl: previewUrl,
            artworkLowQuality: artworkLowQuality,
            trackTimeMilliseconds: trackTimeMilliseconds
        )
    }
}
