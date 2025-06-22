//
//  ITunesSongsAndDetailsFromAlbumResponse.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//

struct ITunesSongsAndDetailsFromAlbumResponse: Decodable {
    let resultCount: Int
    let results: [ITunesSongsFromAlbumResult]
}

enum ITunesSongsFromAlbumResult: Decodable {
    case album(Album)
    case song(Song)

    private enum CodingKeys: String, CodingKey {
        case wrapperType
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrapperType = try container.decode(String.self, forKey: .wrapperType)

        switch wrapperType {
        case "collection":
            let album = try Album(from: decoder)
            self = .album(album)
        case "track":
            let song = try Song(from: decoder)
            self = .song(song)
        default:
            throw DecodingError.dataCorruptedError(forKey: .wrapperType, in: container, debugDescription: "Unknown wrapper type: \(wrapperType)")
        }
    }
}
