//
//  Home.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    init(viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
            NavigationStack {
                VStack(alignment: .leading) {
                    List(viewModel.songs, id: \.trackId) { song in
                        NavigationLink(value: song) {
                            VStack(alignment: .leading) {
                                ListItem(song: song)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                .init(
                                    top: 8,
                                    leading: 16,
                                    bottom: 8,
                                    trailing: 16
                                )
                            )
                            .onAppear {
                                if song == viewModel.songs.last {
                                    Task { [viewModel] in
                                        await viewModel.loadMore()
                                    }
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                    }
                    .searchable(text: $viewModel.searchTerm, prompt: "Search")
                    .navigationTitle("Songs")
                    .listStyle(.plain)
                    .navigationDestination(for: Song.self) { song in
                        SongDetailsView(viewModel: SongDetailsViewModel(song: song))
                    }

                    if viewModel.isLoadingMore {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
}

#Preview {
    HomeView()
}
