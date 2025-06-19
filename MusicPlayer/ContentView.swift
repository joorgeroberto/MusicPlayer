////
////  ContentView.swift
////  MusicPlayer
////
////  Created by Jorge de Carvalho on 18/06/25.
////
//
import SwiftUI
import AVFoundation
//import CoreData
//
//struct ContentView: View {
//    @Environment(\.managedObjectContext) private var viewContext
//
//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()
//
//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

class AudioPlayerViewModel: ObservableObject {
    var player: AVPlayer?

    func playAudio(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("URL inválida")
            return
        }

        player = AVPlayer(url: url)
        player?.play()
    }

    func stopAudio() {
        player?.pause()
        player = nil
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AudioPlayerViewModel()

    var body: some View {
        VStack(spacing: 20) {
            Button("▶️ Play Preview") {
                let previewUrl = "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/28/18/9c/28189c6f-bca9-27bb-98bb-11f98f771acc/mzaf_11540048934676893441.plus.aac.p.m4a"
                viewModel.playAudio(from: previewUrl)
            }

            Button("⏹️ Stop") {
                viewModel.stopAudio()
            }
        }
        .padding()
    }
}
