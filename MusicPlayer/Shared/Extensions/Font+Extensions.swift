//
//  Font+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 19/06/25.
//

import SwiftUI

extension Font {
    enum CustomFontSize: CGFloat {
        /// 12
        case small = 12
        /// 14
        case medium = 14
        /// 16
        case large = 16
        /// 18
        case xLarge = 18
        /// 24
        case xxLarge = 24
    }

    enum CustomFontWeight {
        case regular
        case semibold
        case bold

        var swiftUIFontWeight: Font.Weight {
            switch self {
            case .regular: return .regular
            case .semibold: return .semibold
            case .bold: return .bold
            }
        }
    }

    static func custom(_ size: CustomFontSize, _ weight: CustomFontWeight) -> Font {
        return .system(size: size.rawValue, weight: weight.swiftUIFontWeight)
    }
}
