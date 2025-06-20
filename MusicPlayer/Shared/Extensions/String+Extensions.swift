//
//  String+Extensions.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 20/06/25.
//

extension String {
    func replacingImageSize(to size: Int) -> String {
        return self.replacingOccurrences(
            of: #"/\d+x\d+bb\.jpg"#,
            with: "/\(size)x\(size)bb.jpg",
            options: .regularExpression
        )
    }
}
