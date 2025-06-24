//
//  ErrorAlertViewModelTests.swift
//  MusicPlayer
//
//  Created by Jorge de Carvalho on 23/06/25.
//

import SwiftUI
import Testing
@testable import MusicPlayer

@Suite("ErrorAlertViewModel Tests") struct ErrorAlertViewModelTests {
    @Suite("showErrorAlert() Tests") struct showErrorAlert {
        @MainActor @Test func givenSpecificErrorMessage_whenShowErrorAlertFunctionIsCalled_thenErrorMessageIsSetAndAlertIsPresented() {
            // Given
            let errorAlertMessage = "Please try again!"
            let sut = ErrorAlertViewModel()
            
            // When
            sut.showErrorAlert(errorAlertMessage: errorAlertMessage)

            // Then
            #expect(sut.errorAlertMessage == errorAlertMessage)
            #expect(sut.isErrorAlertPresented)
        }
    }
}
