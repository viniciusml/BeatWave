//
//  CredentialCachePolicy.swift
//  BeatWave
//
//  Created by Vinicius Leal on 03/09/2024.
//

import Foundation

enum CredentialCachePolicy {
    
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static let maxCacheAgeInDays: Int = 7
    
    static func validate(_ timestamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = maxCacheAge(timestamp) else {
            return false
        }
        return date < maxCacheAge
    }
    
    private static func maxCacheAge(_ timestamp: Date) -> Date? {
        calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp)
    }
}
