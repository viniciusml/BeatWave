//
//  HomeViewModel.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    private let audioPlayer: AudioPlaying
    @Published var state: PlayerState = .idle
    
    init(audioPlayer: AudioPlaying) {
        self.audioPlayer = audioPlayer
    }
    
    func performAction(_ action: Action) {
        switch action {
        case .changeState:
            switchPlayerState()
        }
    }
    
    private func switchPlayerState() {
        switch state {
        case .idle:
            audioPlayer.play()
            state = .playing
        case .playing:
            audioPlayer.pause()
            state = .paused
        case .paused:
            audioPlayer.play()
            state = .paused
        }
    }
}

extension HomeViewModel {
    
    enum Action {
        case changeState
    }
    
    enum PlayerState {
        case idle
        case playing
        case paused
    }
}
