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
