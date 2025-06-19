//
//  HomeViewModel.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import Combine
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var songs: [Song] = []
    @Published private(set) var isLoadingMore = false

    private let iTunesService: ITunesServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var offset = 0
    private var limit = 50

    init(iTunesService: ITunesServiceProtocol = ITunesService()) {
        self.iTunesService = iTunesService
        self.setupSearchDebounce()
    }

    private func setupSearchDebounce() {
        $searchTerm
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task {
                    await self?.fetchMusicList()
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    func loadMore() async {
        guard !isLoadingMore, !searchTerm.isEmpty else { return }

        isLoadingMore = true
        defer { isLoadingMore = false }
        do {
            let response: ITunesSearchResponse = try await iTunesService.fetchMusicList(
                term: searchTerm,
                offset: offset,
                limit: limit
            )
            let existingIds = Set(songs.map { $0.trackId })

            let filteredSongs = response.results.filter { !existingIds.contains($0.trackId) }
            songs.append(contentsOf: filteredSongs)
            offset += limit
        } catch {
            // TODO: Add Error Alert
        }
    }

    @MainActor
    func fetchMusicList() async {
        guard !searchTerm.isEmpty else {
            songs = []
            return
        }

        offset = 0
        do {
            let response: ITunesSearchResponse = try await self.iTunesService.fetchMusicList(
                term: searchTerm,
                offset: offset,
                limit: limit
            )
            songs = response.results
            offset += limit
        } catch {
            // TODO: Add Error Alert
        }
    }
}
