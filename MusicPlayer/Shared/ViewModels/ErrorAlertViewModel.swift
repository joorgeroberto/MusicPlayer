//
//  ErrorAlertViewModel.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 23/06/25.
//

import SwiftUI

@MainActor
class ErrorAlertViewModel: ObservableObject {
    @Published var errorAlertMessage  = ""
    @Published var isErrorAlertPresented = false

    func showErrorAlert(errorAlertMessage: String = "Please try again!") {
        self.errorAlertMessage = errorAlertMessage
        self.isErrorAlertPresented = true
    }
}
