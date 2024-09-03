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
    
    let credentialLoader = CredentialLoader(
        store: KeychainCredentialStore(),
        currentDate: Date.init)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
}
