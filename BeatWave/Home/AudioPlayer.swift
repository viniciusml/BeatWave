//
//  AudioPlayer.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import AVFoundation

struct Song {
    let url: URL
}

final class ResourceProvider {
    
    enum FileType: String {
        case mp3 = ".mp3"
    }
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func retrieveSongsFromAssets(_ fileType: FileType, directory: String) -> [Song] {
        // For simplicity, I am getting only the URL's and not handling unhappy path, but ideally errors could be handled here.
        // Also, for now I am not getting the metadata for the file, but could be achieved.
        bundle.paths(forResourcesOfType: fileType.rawValue, inDirectory: directory)
            .lazy
            .compactMap { URL(string: $0) }
            .map { Song(url: $0) }
    }
}

enum AVAudioPlayerFactory {
    
    static func makePlayer(for url: URL) throws -> AVAudioPlayer {
        try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
    }
}

final class AudioPlayer {
    
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
