//
//  ValidateCredentialUseCaseTests.swift
//  BeatWaveTests
//
//  Created by Vinicius Leal on 04/09/2024.
//

import XCTest
@testable import BeatWave

final class ValidateCredentialUseCaseTests: XCTestCase {
    
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.logs, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache { _ in }
        store.completeLoad(with: anyNSError())
        
        XCTAssertEqual(store.logs, [.load, .clear])
    }
    
    func test_validateCache_doesNotDeleteNonExpiredCache() {
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache { _ in }
        store.completeLoadSuccessfully(with: nonExpiredTimestamp)
        
        XCTAssertEqual(store.logs, [.load])
    }
    
    func test_validateCache_deletesCacheOnExpiration() {
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache { _ in }
        store.completeLoadSuccessfully(with: expirationTimestamp)
        
        XCTAssertEqual(store.logs, [.load, .clear])
    }
    
    func test_validateCache_deletesExpiredCache() {
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache { _ in }
        store.completeLoadSuccessfully(with: expiredTimestamp)
        
        XCTAssertEqual(store.logs, [.load, .clear])
    }
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfFailedRetrieval() {
        let (sut, store) = makeSUT()
        
        sut.validateCache { _ in }
        store.completeLoad(with: anyNSError())
        
        XCTAssertEqual(store.logs, [.load, .clear])
    }
    
    func test_validateCache_succeedsOnNonExpiredCache() {
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        expect(sut, toCompleteWith: .success(()), when: {
            store.completeLoadSuccessfully(with: nonExpiredTimestamp)
        })
        
        XCTAssertEqual(store.logs, [.load])
    }
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfExpiredCache() {
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        
        sut.validateCache { _ in }
        store.completeLoadSuccessfully(with: expiredTimestamp)
        
        XCTAssertEqual(store.logs, [.load, .clear])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = CredentialStoreSpy()
        var sut: CredentialLoader? = CredentialLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache { _ in }
        
        sut = nil
        store.completeLoad(with: anyNSError())
        
        XCTAssertEqual(store.logs, [.load])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentDate: @escaping () -> Date = Date.init) -> (sut: CredentialLoader, store: CredentialStoreSpy) {
        let store = CredentialStoreSpy()
        let sut = CredentialLoader(store: store, currentDate: currentDate)
        return (sut, store)
    }
    
    func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }
    
    private func expect(_ sut: CredentialLoader, toCompleteWith expectedResult: CredentialLoader.ValidationResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for completion")
        
        sut.validateCache { receivedResult in
            switch (receivedResult, expectedResult) {
            case (.success, .success):
                break
                
            case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
}

private extension ValidateCredentialUseCaseTests {
    
    final class CredentialStoreSpy: CredentialStore {
        
        enum MethodCall: Equatable {
            case save(LocalCredential, Date)
            case load
            case clear
        }
        
        private var saveCompletions = [(SaveResult) -> Void]()
        private var loadCompletions = [(LoadResult) -> Void]()
        
        private(set) var logs: [MethodCall] = []
        
        func save(_ credential: LocalCredential, timestamp: Date, completion: @escaping (SaveResult) -> Void) {
            saveCompletions.append(completion)
            logs.append(.save(credential, timestamp))
        }
        
        func completeSave(with error: Error, at index: Int = 0) {
            saveCompletions[index](.failure(error))
        }
        
        func completeSaveSuccessfully(at index: Int = 0) {
            saveCompletions[index](.success(()))
        }
        
        func load(_ completion: @escaping (LoadResult) -> Void) {
            loadCompletions.append(completion)
            logs.append(.load)
        }
        
        func completeLoad(with error: Error, at index: Int = 0) {
            loadCompletions[index](.failure(error))
        }
        
        func completeLoadSuccessfully(with date: Date, at index: Int = 0) {
            loadCompletions[index](.success(date))
        }
        
        func clear() {
            logs.append(.clear)
        }
    }
}

private extension Date {
    func minusCacheMaxAge() -> Date {
        adding(days: -cacheMaxAgeInDays)
    }
    
    func adding(seconds: TimeInterval) -> Date {
        self + seconds
    }
    
    func adding(days: Int, calendar: Calendar = Calendar(identifier: .gregorian)) -> Date {
        calendar.date(byAdding: .day, value: days, to: self)!
    }
    
    private var cacheMaxAgeInDays: Int {
        7
    }
}
