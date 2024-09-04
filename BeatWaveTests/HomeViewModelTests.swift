//
//  HomeViewModelTests.swift
//  BeatWaveTests
//
//  Created by Vinicius Leal on 04/09/2024.
//

@testable import BeatWave
import XCTest

final class HomeViewModelTests: XCTestCase {
    
    func test_changeState() {
        let (audioPlayer, sut) = makeSUT()
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(audioPlayer.logs, [])
        
        sut.performAction(.changeState)
        
        XCTAssertEqual(sut.state, .playing)
        XCTAssertEqual(audioPlayer.logs, [.play])
        
        sut.performAction(.changeState)
        
        XCTAssertEqual(sut.state, .paused)
        XCTAssertEqual(audioPlayer.logs, [.play, .pause])
        
        sut.performAction(.changeState)
        
        XCTAssertEqual(sut.state, .playing)
        XCTAssertEqual(audioPlayer.logs, [.play, .pause, .play])
    }
}

private extension HomeViewModelTests {
    
    func makeSUT() -> (audioPlayer: AudioPlayerSpy, sut: HomeViewModel) {
        let audioPlayer = AudioPlayerSpy()
        let sut = HomeViewModel(audioPlayer: audioPlayer)
        return (audioPlayer, sut)
    }
    
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
