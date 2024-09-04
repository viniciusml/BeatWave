//
//  AudioPlayer.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import AVFoundation

final class AudioPlayer {
    
    private let player: AVAudioPlayer
    private let audioSession: AVAudioSession
    
    // AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//    guard let url = Bundle.main.url(forResource: "soundName", withExtension: "mp3") else {
//        print("url not found")
//        return
//    }
    
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
