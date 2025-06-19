//
//  SongDetailsView.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

struct SongDetailsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
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
                    dismiss()
                } label: {
                    Image("ic-more")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 48, height: 48)

            }
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .padding(.leading, 12)
        .padding(.trailing, 12)
    }
}

#Preview {
    SongDetailsView()
        .preferredColorScheme(.dark)
}
