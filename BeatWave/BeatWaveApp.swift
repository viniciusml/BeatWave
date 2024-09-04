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
                .onAppear {
                    viewRegistry.currentView = .logIn(
                        LoginView(
                            viewModel: LoginViewModel(
                                credentialLoader: credentialLoader,
                                viewRegistry: viewRegistry))
                    )
                }
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

final class Coordinator {
    
    enum Destination {
        case login
        case home
    }
    
    private let registry: ViewRegistry
    private let credentialLoader: CredentialCache
    
    public init(credentialLoader: CredentialCache, registry: ViewRegistry) {
        self.credentialLoader = credentialLoader
        self.registry = registry
        
        skipLoginIfPossible()
    }
    
    func changeTo(_ destination: Destination) {
        switch destination {
        case .login:
            registry.currentView = .logIn(
                LoginView(viewModel: LoginViewModel(credentialLoader: credentialLoader, viewRegistry: registry))
            )
        case .home:
            registry.currentView = .home(
                EmptyView()
            )
        }
    }
    
    private func skipLoginIfPossible() {
        credentialLoader.load { [weak self] result in
            guard ((try? result.get()) != nil) else {
                return
            }
            self?.changeTo(.home)
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
        case let .home(view): return AnyView(view.background(Color.yellow))
        case .none: return AnyView(EmptyView().background(Color.red))
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
