//
//  HomeViewModel.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import Foundation

final class HomeViewModel {
    
    init() {
    }
    
    func performAction(_ action: Action) {
        switch action {
        case .changeState:
            ()
        case .next:
            ()
        case .previous:
            ()
        }
    }
}

extension HomeViewModel {
    
    enum Action {
        case changeState
        case next
        case previous
    }
    
    enum Update {
        
        enum InitiatedState {
            case playing
            case paused
        }
        
        case idle
        case initiated(InitiatedState)
    }
}
