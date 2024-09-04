//
//  ResourceProvider.swift
//  BeatWave
//
//  Created by Vinicius Leal on 04/09/2024.
//

import Foundation

enum FileType: String {
    case mp3 = ".mp3"
}

protocol ResourceProviding {
    func retrieveSongsFromAssets(_ fileType: FileType, directory: String) -> [Song]
}

final class ResourceProvider: ResourceProviding {
    
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
