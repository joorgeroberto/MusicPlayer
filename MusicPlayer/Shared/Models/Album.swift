//
//  Album.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//
struct Album: Codable, Identifiable, Equatable, Hashable, ArtworkUpgradable {
    let artistId: Int
    let artistName: String
    let albumId: Int
    let albumName: String
    let trackCount: Int
    var artworkLowQuality: String
    var id: Int { albumId }

    private enum CodingKeys: String, CodingKey {
        case artistId
        case artistName
        case albumId = "collectionId"
        case albumName = "collectionName"
        case trackCount
        case artworkLowQuality = "artworkUrl100"
    }
}

extension Album {
    func setupArtworkHighQuality(size: Int = 600) -> String {
        return artworkLowQuality.replacingOccurrences(
            of: #"/\d+x\d+bb\.jpg"#,
            with: "/\(size)x\(size)bb.jpg",
            options: .regularExpression
        )
    }
}

extension Album {
    static func sample(
        artistId: Int = 1147165685,
        artistName: String = "Iron Maiden",
        albumId: Int = 1147165685,
        albumName: String = "The Number of the Beast (2015 Remaster)",
        trackCount: Int = 8,
        artworkLowQuality: String = "https://is1-ssl.mzstatic.com/image/thumb/Music115/v4/12/6b/44/126b4441-6747-c411-b765-7e54aefbf79f/881034134448.jpg/100x100bb.jpg"
    ) -> Self {
        .init(
            artistId: artistId,
            artistName: artistName,
            albumId: albumId,
            albumName: albumName,
            trackCount: trackCount,
            artworkLowQuality: artworkLowQuality
        )
    }
}
