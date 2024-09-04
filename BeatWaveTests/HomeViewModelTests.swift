//
//  HomeViewModelTests.swift
//  BeatWaveTests
//
//  Created by Vinicius Leal on 04/09/2024.
//

@testable import BeatWave
import XCTest

final class HomeViewModelTests: XCTestCase {
    
    func test_changeState_fromIdle() {
        let audioPlayer = AudioPlayerSpy()
        let sut = HomeViewModel(audioPlayer: audioPlayer)
        XCTAssertEqual(sut.state, .idle)
        
        sut.performAction(.changeState)
        
        XCTAssertEqual(sut.state, .playing)
    }
}

private extension HomeViewModelTests {
    
    final class AudioPlayerSpy: AudioPlaying {
        
        enum MethodCall: Equatable {
            case play
            case pause
        }
        
        private(set) var logs: [MethodCall] = []
        
        func play() {
            logs.append(.play)
        }
        
        func pause() {
            logs.append(.pause)
        }
    }
}
