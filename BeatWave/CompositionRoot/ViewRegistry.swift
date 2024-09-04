//
//  ViewRegistry.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import SwiftUI

class ViewRegistry: ObservableObject {
    enum CurrentView {
        case logIn(LoginView)
        case home(HomeView)
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
