//
//  CredentialLoader.swift
//  BeatWave
//
//  Created by Vinicius Leal on 03/09/2024.
//

import Foundation

protocol CredentialCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(username: String, password: String, timestamp: Date, completion: @escaping (Result) -> Void)
}

final class CredentialLoader {
    private let store: CredentialStore
    private let currentDate: () -> Date
    
    init(store: CredentialStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

extension CredentialLoader: CredentialCache {
    public typealias SaveResult = CredentialCache.Result
    
    func save(username: String, password: String, timestamp: Date, completion: @escaping (SaveResult) -> Void) {
        cache(username: username, password: password, timestamp: timestamp, completion: completion)
    }
    
    private func cache(username: String, password: String, timestamp: Date, completion: @escaping (SaveResult) -> Void) {
        store.clear()
        store.save(LocalCredential(username, password), timestamp: timestamp, completion: completion)
    }
}

extension CredentialLoader {
    public typealias LoadResult = Swift.Result<Void, Error>
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.load { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let timestamp) where CredentialCachePolicy.validate(timestamp, against: currentDate()):
                completion(.success(()))
                
            case .success:
                completion(.success(()))
            }
        }
    }
}

extension CredentialLoader {
    typealias ValidationResult = Result<Void, Error>
    
    func validateCache(completion: @escaping (ValidationResult) -> Void) {
        store.load { [weak self] result in
            guard let self else { return }
            
            switch result {
                case .failure:
                store.clear()
                
                case .success(let timestamp) where !CredentialCachePolicy.validate(timestamp, against: currentDate()):
                store.clear()
                
                case .success:
                completion(.success(()))
            }
        }
    }
}
