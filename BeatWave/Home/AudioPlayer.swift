//
//  AudioPlayer.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import AVFoundation

protocol AudioPlaying {
    func play()
    func pause()
}

final class AudioPlayer: AudioPlaying {
    
    private let player: AVAudioPlayer
    private let audioSession: AVAudioSession
    
    init(player: AVAudioPlayer, audioSession: AVAudioSession = .sharedInstance()) {
        self.player = player
        self.audioSession = audioSession
    }
    
    func play() {
        do {
            try setPlaybackMode()
            
            player.play()
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func pause() {
        player.pause()
    }
    
    private func setPlaybackMode() throws {
        try audioSession.setCategory(AVAudioSession.Category.playback)
        try audioSession.setActive(true)
    }
}
