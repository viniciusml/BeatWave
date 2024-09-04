//
//  AVAudioPlayerFactory.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import AVFoundation

enum AVAudioPlayerFactory {
    
    static func makePlayer(for url: URL) throws -> AVAudioPlayer {
        try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
    }
}
