//
//  ITunesSearchResponse.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 21/06/25.
//

struct ITunesSearchResponse: Codable {
    let resultCount: Int
    let results: [Song]
}
