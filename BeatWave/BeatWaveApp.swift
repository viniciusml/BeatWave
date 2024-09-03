//
//  BeatWaveApp.swift
//  BeatWave
//
//  Created by Vinicius Leal on 02/09/2024.
//

import SwiftUI

@main
struct BeatWaveApp: App {
    
    var diContainer = DependencyContainer()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            diContainer.signInStrategy.makeInitialView()
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .background, .active:
                diContainer.credentialLoader.validateCache { _ in }
            default:
                break
            }
        }
    }
}

struct DependencyContainer {
    var credentialLoader: CredentialCache
    @ObservedObject var signInStrategy: SignInStrategy
    
    init(
        credentialStore: CredentialStore = KeychainCredentialStore(),
        currentDate: @escaping () -> Date = Date.init
    ) {
        self.credentialLoader = CredentialLoader(store: credentialStore, currentDate: currentDate)
        self.signInStrategy = SignInStrategy(credentialLoader: credentialLoader)
    }
}

final class SignInStrategy: ObservableObject {
    
    @Published private var isLoggedIn: Bool = false
    
    private let credentialLoader: CredentialCache
    
    public init(credentialLoader: CredentialCache) {
        self.credentialLoader = credentialLoader
        
        credentialLoader.load { result in
            guard ((try? result.get()) != nil) else {
                return
            }
            self.isLoggedIn = true
        }
    }
    
    @ViewBuilder
    func makeInitialView() -> some View {
        switch isLoggedIn {
        case true:
            
            EmptyView() //music view, login is valid
        case false:
            
            LoginView(viewModel: LoginViewModel(credentialLoader: credentialLoader))
        }
    }
}
