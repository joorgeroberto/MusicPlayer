//
//  Color+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

extension Color {
    struct Text {
        static let primary = Color.white
        static let secondary = Color(red: 115/255, green: 115/255, blue: 115/255)
    }

    struct Background {
        static let primary = Color.black
        static let secondary = Color.white.opacity(0.1)
    }
}
