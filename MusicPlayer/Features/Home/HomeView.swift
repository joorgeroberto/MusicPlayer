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
                Group {
                    if viewModel.showEmptyState() {
                        EmptyState
                    } else if viewModel.showProgressView() {
                        ProgressView
                    } else {
                        SongList
                    }
                }
                .alert("Something went wrong...", isPresented: $viewModel.isErrorAlertPresented) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.errorAlertMessage)
                }

                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        SwiftUI.ProgressView()
                            .padding()
                        Spacer()
                    }
                }
            }
            .searchable(text: $viewModel.searchTerm, prompt: "Search")
            .navigationTitle("Songs")
        }
    }

    private var EmptyState: some View {
        Group {
            Spacer()
            Text("Start typing to search for songs.")
                .foregroundColor(.gray)
                .font(.custom(.xLarge, .regular))
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }

    private var ProgressView: some View {
        Group {
            Spacer()
            SwiftUI.ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
            Spacer()
        }
    }

    private var SongList: some View {
        List(viewModel.songs, id: \.trackId) { song in
            VStack(alignment: .leading) {
                SongListRow(song: song)
            }
            .listRowSeparator(.hidden)
            .onAppear {
                if song == viewModel.songs.last {
                    Task { [viewModel] in
                        await viewModel.loadMore()
                    }
                }
            }
            .onTapGesture {
                viewModel.selectedSong = song
            }
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationDestination(item: $viewModel.selectedSong) { song in
            SongDetailsView(viewModel: SongDetailsViewModel(song: song))
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
