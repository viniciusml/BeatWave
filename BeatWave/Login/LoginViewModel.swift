//
//  LoginViewModel.swift
//  BeatWave
//
//  Created by Vinicius Leal on 03/09/2024.
//

import Foundation
import SwiftUI

final class LoginViewModel {
    
    private let credentialLoader: CredentialCache
    private let viewRegistry: ViewRegistry
    
    init(credentialLoader: CredentialCache, viewRegistry: ViewRegistry) {
        self.credentialLoader = credentialLoader
        self.viewRegistry = viewRegistry
    }
    
    func performAction(_ action: Action) {
        switch action {
        case let .didPressLogIn(username, password):
            credentialLoader.save(username: username, password: password, timestamp: Date.now) { [weak self] _ in
                withAnimation {
                    self?.viewRegistry.currentView = .home(HomeView())
                }
            }
        }
    }
}

extension LoginViewModel {
    
    enum Action {
        case didPressLogIn(username: String, password: String)
    }
}
