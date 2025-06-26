//
//  SongDetailsHeader.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 20/06/25.
//

import SwiftUI

struct SongDetailsHeader: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showMoreOptionsBottomSheet: Bool

    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image("ic-arrow-left")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 48, height: 48)

            Spacer()

            Button {
                showMoreOptionsBottomSheet.toggle()
            } label: {
                Image("ic-more")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .frame(width: 48, height: 48)

        }
    }
}
