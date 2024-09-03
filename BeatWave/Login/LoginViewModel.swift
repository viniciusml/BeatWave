//
//  LoginViewModel.swift
//  BeatWave
//
//  Created by Vinicius Leal on 03/09/2024.
//

import Foundation

final class LoginViewModel {
    
    func performAction(_ action: Action) {
        switch action {
        case .didPressLogIn:
            // perform login action
            break
        }
    }
}

extension LoginViewModel {
    
    enum Action {
        case didPressLogIn(username: String, password: String)
    }
}
