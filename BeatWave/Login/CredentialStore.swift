//
//  CredentialStore.swift
//  BeatWave
//
//  Created by Vinicius Leal on 03/09/2024.
//

import Foundation

typealias CacheCredentialTimestamp = Date

protocol CredentialStore {
    typealias SaveResult = Swift.Result<Void, Error>
    typealias LoadResult = Swift.Result<CacheCredentialTimestamp, Error>
    
    func save(_ credential: LocalCredential, timestamp: Date, completion: @escaping (SaveResult) -> Void)
    func load(_ completion: @escaping (LoadResult) -> Void)
    func clear()
}

final class KeychainCredentialStore {
    
    enum Error: Swift.Error {
        case dataNotFound
        case saveFailed
    }

    private struct Credential: Codable {
        let username: String
        let password: String
        let timestamp: Date
        
        init(_ credential: LocalCredential, _ timestamp: Date) {
            self.username = credential.username
            self.password = credential.password
            self.timestamp = timestamp
        }
    }
    
    private let key = "KeychainCredentialStore.key"
    
    init() {}
}

extension KeychainCredentialStore: CredentialStore {
    
    public func clear() {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary
        
        SecItemDelete(query)
    }
    
    func save(_ credential: LocalCredential, timestamp: Date, completion: @escaping (CredentialStore.SaveResult) -> Void) {
        do {
            let data = try JSONEncoder().encode(Credential(credential, timestamp))
            
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrAccount: key,
                kSecValueData: data
            ] as CFDictionary
            
            SecItemDelete(query)
            
            guard SecItemAdd(query, nil) == noErr else {
                throw Error.saveFailed
            }
            
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func load(_ completion: @escaping (CredentialStore.LoadResult) -> Void) {
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == noErr, let data = result as? Data else {
            return completion(.failure(Error.dataNotFound))
        }
        
        do {
            // If we had an endpoint to perform login, perhaps this could return the credentials.
            // However, it would be safer to deal with oauth token.
            let credential = try JSONDecoder().decode(Credential.self, from: data)
            completion(.success(credential.timestamp))
        } catch {
            completion(.failure(error))
        }
    }
}
