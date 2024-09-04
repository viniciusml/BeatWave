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
                viewRegistry.currentView = .home(
                    EmptyView()
                )
            case .failure:
                viewRegistry.currentView = .logIn(
                    LoginView(
                        viewModel: LoginViewModel(
                            credentialLoader: credentialLoader,
                            viewRegistry: viewRegistry))
                )
            }
        }
    }
}

class ViewRegistry: ObservableObject {
    enum CurrentView {
        case logIn(LoginView)
        case home(EmptyView)
    }
    
    @Published var currentView: CurrentView?
    
    var view: AnyView {
        switch currentView {
        case let .logIn(view): return AnyView(view)
        case let .home(view): return AnyView(view)
        case .none: return AnyView(EmptyView())
        }
    }
}

struct NavigationView: View {
    @ObservedObject var registry: ViewRegistry
    
    var body: some View {
        registry.view
            .transition(
                AnyTransition
                    .opacity
                    .combined(with: .move(edge: .trailing))
            )
            .id(UUID())
    }
}
