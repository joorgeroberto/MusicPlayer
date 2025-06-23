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
                        .onAppear {
                            if song == viewModel.songs.last {
                                Task { [viewModel] in
                                    await viewModel.loadMore()
                                }
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
                .searchable(text: $viewModel.searchTerm, prompt: "Search")
                .navigationTitle("Songs")
                .listStyle(.plain)
                .navigationDestination(for: Song.self) { song in
                    SongDetailsView(viewModel: SongDetailsViewModel(song: song))
                }
                .alert("Something went wrong...", isPresented: $viewModel.isErrorAlertPresented) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.errorAlertMessage)
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

#Preview("Empty State") {
    HomeView()
        .preferredColorScheme(.dark)
}

#Preview("Populated") {
    let viewModel = HomeViewModel()
    viewModel.searchTerm = Song.sample().artistName
    return HomeView(viewModel: viewModel)
        .preferredColorScheme(.dark)
}
