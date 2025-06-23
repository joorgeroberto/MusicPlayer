//
//  URLSessionSpy.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 22/06/25.
//

import SwiftUI
@testable import MusicPlayer

final class URLSessionSpy: URLSessionProtocol {
    var dataCallCount = 0
    var dataToBeReturned: Data?
    var responseToBeReturned: URLResponse?
    var errorToThrow: Error?

    func data(from url: URL) async throws -> (Data, URLResponse) {
        dataCallCount += 1

        if let error = errorToThrow {
            throw error
        }

        guard let data = dataToBeReturned, let response = responseToBeReturned else {
            fatalError("Mocked data and response must be set before calling data(from:)")
        }

        return (data, response)
    }
}
