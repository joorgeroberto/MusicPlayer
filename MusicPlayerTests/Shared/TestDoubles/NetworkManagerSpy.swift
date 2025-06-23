//
//  NetworkManagerSpy.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import SwiftUI
@testable import MusicPlayer

final class NetworkManagerSpy: NetworkManagerProtocol {
    var fetchCallCount = 0
    var capturedURL: URL?
    var errorToThrow: Error?
    var resultToBeReturned: Any?

    func fetch<T>(url: URL) async throws -> T where T : Decodable {
        fetchCallCount += 1
        capturedURL = url

        if let error = errorToThrow {
            throw error
        }

        guard let result = resultToBeReturned as? T else {
            fatalError("Spy: Type mismatch or resultToBeReturned not set")
        }

        return result
    }
}
