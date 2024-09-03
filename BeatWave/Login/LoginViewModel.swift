//
//  LoginViewModel.swift
//  BeatWave
//
//  Created by Vinicius Leal on 03/09/2024.
//

import Foundation

final class LoginViewModel {
    
    private let credentialLoader: CredentialCache
    
    init(credentialLoader: CredentialCache) {
        self.credentialLoader = credentialLoader
    }
    
    func performAction(_ action: Action) {
        switch action {
        case let .didPressLogIn(username, password):
            credentialLoader.save(username: username, password: password, timestamp: Date.now) { _ in
                // handle errors
            }
        }
    }
}

extension LoginViewModel {
    
    enum Action {
        case didPressLogIn(username: String, password: String)
    }
}
