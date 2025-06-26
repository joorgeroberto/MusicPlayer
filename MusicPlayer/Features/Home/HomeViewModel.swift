//
//  HomeViewModel.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import Combine
import SwiftUI

@MainActor
class HomeViewModel: ErrorAlertViewModel {
    @Published var searchTerm = ""
    @Published var songs: [Song] = []
    @Published var selectedSong: Song?
    @Published var isLoadingMore = false
    @Published var isFetchingMusicList = false

    private let iTunesService: ITunesServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private(set) var offset = 0
    private(set) var limit = 50

    init(iTunesService: ITunesServiceProtocol = ITunesService()) {
        self.iTunesService = iTunesService
        super.init()
        self.setupSearchDebounce()
    }

    func showEmptyState() -> Bool {
        return searchTerm.isEmpty
    }

    func showProgressView() -> Bool {
        return songs.isEmpty && isFetchingMusicList
    }
}

// MARK: API Calls
extension HomeViewModel {
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
            searchTerm = ""
            showErrorAlert()
        }
    }

    func fetchMusicList() async {
        guard !isFetchingMusicList, !searchTerm.isEmpty else {
            songs = []
            return
        }

        isFetchingMusicList = true
        defer { isFetchingMusicList = false }
        offset = 0
        do {
            let response: ITunesSearchResponse = try await iTunesService.fetchMusicList(
                term: searchTerm,
                offset: offset,
                limit: limit
            )
            songs = response.results
            offset += limit
        } catch {
            searchTerm = ""
            showErrorAlert()
        }
    }
}

// MARK: Private functions
private extension HomeViewModel {
    func setupSearchDebounce() {
        $searchTerm
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    await self?.fetchMusicList()
                }
            }
            .store(in: &cancellables)
    }
}
