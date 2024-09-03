//
//  LocalCredential.swift
//  BeatWave
//
//  Created by Vinicius Leal on 03/09/2024.
//

import Foundation

struct LocalCredential {
    let username: String
    let password: String
    
    init(_ username: String, _ password: String) {
        self.username = username
        self.password = password
    }
}
