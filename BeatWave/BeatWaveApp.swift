//
//  BeatWaveApp.swift
//  BeatWave
//
//  Created by Vinicius Leal on 02/09/2024.
//

import SwiftUI

@main
struct BeatWaveApp: App {
    
    let credentialLoader = CredentialLoader(store: KeychainCredentialStore(), currentDate: Date.init)
    @StateObject var viewRegistry = ViewRegistry()
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            NavigationView(registry: viewRegistry)
                .onAppear(perform: setInitialView)
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .background, .active:
                credentialLoader.validateCache { _ in }
            default:
                break
            }
        }
    }
    
    private func setInitialView() {
        credentialLoader.load { result in
            switch result {
            case .success:
                viewRegistry.setCurrentView(.home(
                    HomeView()
                ))
            case .failure:
                viewRegistry.setCurrentView(.logIn(
                    LoginView(
                        viewModel: LoginViewModel(
                            credentialLoader: credentialLoader,
                            viewRegistry: viewRegistry))
                ))
            }
        }
    }
}
