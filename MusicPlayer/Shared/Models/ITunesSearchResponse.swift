//
//  ITunesSearchResponse.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//

struct ITunesSearchResponse: Decodable {
    let resultCount: Int
    let results: [Song]
}

// MARK: Fixture
extension ITunesSearchResponse {
    static func sample(
        resultCount: Int = 2,
        results: [Song] = [
            Song.sample(),
            Song.sample()
        ]
    ) -> Self {
        .init(
            resultCount: resultCount,
            results: results
        )
    }
}
