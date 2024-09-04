//
//  ResourceProviderTests.swift
//  BeatWaveTests
//
//  Created by Vinicius Leal on 04/09/2024.
//

@testable import BeatWave
import XCTest

final class ResourceProviderTests: XCTestCase {
    
    func test_retrieveSongsFromAssets() throws {
        let validURL = try XCTUnwrap(URL(string: "https://a-valid-path.com"))
        let testDirectory = "testDirectory/path"
        let bundle = BundleSpy(stubbedPaths: [
            "https://a-valid-path.com"
        ])
        let sut = ResourceProvider(bundle: bundle)
        
        let songs = sut.retrieveSongsFromAssets(.mp3, directory: testDirectory)
        
        XCTAssertEqual(bundle.logs, [.paths(type: ".mp3", subpath: testDirectory)])
        XCTAssertEqual(songs, [Song(url: validURL)])
    }
}

private extension ResourceProviderTests {
            
    final class BundleSpy: Bundle {
        
        enum MethodCall: Equatable {
            case paths(type: String?, subpath: String?)
        }
        
        private let stubbedPaths: [String]
        private(set) var logs: [MethodCall] = []
        
        init(stubbedPaths: [String]) {
            self.stubbedPaths = stubbedPaths
            super.init()
        }
        
        override func paths(forResourcesOfType ext: String?, inDirectory subpath: String?) -> [String] {
            logs.append(.paths(type: ext, subpath: subpath))
            return stubbedPaths
        }
    }
}
