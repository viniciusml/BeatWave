//
//  BeatWaveApp.swift
//  BeatWave
//
//  Created by Vinicius Leal on 02/09/2024.
//

import SwiftUI

@main
struct BeatWaveApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var compositionRoot = CompositionRoot(credentialLoader: CredentialLoader.init)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { _, newValue in
            switch newValue {
            case .background, .active:
                compositionRoot.credentialLoader.validateCache { _ in }
            default:
                break
            }
        }
    }
}

struct CompositionRoot {
    var credentialLoader: CredentialCache
    
    init(
        credentialStore: CredentialStore = KeychainCredentialStore(),
        currentDate: @escaping () -> Date =  Date.init,
        credentialLoader: (CredentialStore, @escaping () -> Date) -> CredentialCache
    ) {
        self.credentialLoader = credentialLoader(credentialStore, currentDate)
    }
}
