import XCTest

@testable import DealDetailsFeature

final class DealDetailsLoaderAdapterTests: XCTestCase {

    func test_load_producesCombinedSuccessfulLoaderResults() {
        let loader = LoaderStub()
        let sut = DealDetailsLoaderAdapter(dealDeailsLoader: loader, 
                                           tasksLoader: loader,
                                           contactsLoader: loader,
                                           filesLoader: loader,
                                           notesLoader: loader)
        
        let exp = expectation(description: "Wait for completion")
        var result: DealDetailsViewLoader.LoaderResult?
        sut.load(dealID: "1") {
            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(try result?.get(), .mock)
    }
    
    func test_load_failsWithDetailsLoaderError() {
        let loader = LoaderStub()
        loader.detailsLoaderError = NSError(domain: "any", code: 0)
        
        let sut = DealDetailsLoaderAdapter(dealDeailsLoader: loader,
                                           tasksLoader: loader,
                                           contactsLoader: loader,
                                           filesLoader: loader,
                                           notesLoader: loader)
        
        let exp = expectation(description: "Wait for completion")
        var result: DealDetailsViewLoader.LoaderResult?
        sut.load(dealID: "1") {
            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(result?.error as? NSError, loader.detailsLoaderError)
    }
    
    func test_load_failsWithTasksLoaderError() {
        let loader = LoaderStub()
        loader.tasksLoaderError = NSError(domain: "any", code: 0)
        
        let sut = DealDetailsLoaderAdapter(dealDeailsLoader: loader,
                                           tasksLoader: loader,
                                           contactsLoader: loader,
                                           filesLoader: loader,
                                           notesLoader: loader)
        
        let exp = expectation(description: "Wait for completion")
        var result: DealDetailsViewLoader.LoaderResult?
        sut.load(dealID: "1") {
            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(result?.error as? NSError, loader.tasksLoaderError)
    }
    
    func test_load_failsWithContactsLoaderError() {
        let loader = LoaderStub()
        loader.contactsLoaderError = NSError(domain: "any", code: 0)
        
        let sut = DealDetailsLoaderAdapter(dealDeailsLoader: loader,
                                           tasksLoader: loader,
                                           contactsLoader: loader,
                                           filesLoader: loader,
                                           notesLoader: loader)
        
        let exp = expectation(description: "Wait for completion")
        var result: DealDetailsViewLoader.LoaderResult?
        sut.load(dealID: "1") {
            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(result?.error as? NSError, loader.contactsLoaderError)
    }
    
    func test_load_failsWithFilesLoaderError() {
        let loader = LoaderStub()
        loader.filesLoaderError = NSError(domain: "any", code: 0)
        
        let sut = DealDetailsLoaderAdapter(dealDeailsLoader: loader,
                                           tasksLoader: loader,
                                           contactsLoader: loader,
                                           filesLoader: loader,
                                           notesLoader: loader)
        
        let exp = expectation(description: "Wait for completion")
        var result: DealDetailsViewLoader.LoaderResult?
        sut.load(dealID: "1") {
            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(result?.error as? NSError, loader.filesLoaderError)
    }
    
    func test_load_failsWithNotesLoaderError() {
        let loader = LoaderStub()
        loader.notesLoaderError = NSError(domain: "any", code: 0)
        
        let sut = DealDetailsLoaderAdapter(dealDeailsLoader: loader,
                                           tasksLoader: loader,
                                           contactsLoader: loader,
                                           filesLoader: loader,
                                           notesLoader: loader)
        
        let exp = expectation(description: "Wait for completion")
        var result: DealDetailsViewLoader.LoaderResult?
        sut.load(dealID: "1") {
            result = $0
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
        
        XCTAssertEqual(result?.error as? NSError, loader.notesLoaderError)
    }
}

// MARK: - Helpers

private class LoaderStub: DealDetailsLoader, TasksLoader, ContactsLoader, FilesLoader, NotesLoader {
    var detailsLoaderError: NSError?
    var tasksLoaderError: NSError?
    var contactsLoaderError: NSError?
    var filesLoaderError: NSError?
    var notesLoaderError: NSError?

    func load(dealID: String, completion: @escaping (DealDetailsResult) -> Void) {
        DispatchQueue.global().async {
            if let error = self.detailsLoaderError {
                completion(.failure(error))
            } else {
                completion(.success(.mock))
            }
        }
    }
    
    func load(dealID: String, completion: @escaping (TasksResult) -> Void) {
        DispatchQueue.global().async {
            if let error = self.tasksLoaderError {
                completion(.failure(error))
            } else {
                completion(.success([.mock]))
            }
        }
    }
    
    func load(dealID: String, completion: @escaping (ContactsResult) -> Void) {
        DispatchQueue.global().async {
            if let error = self.contactsLoaderError {
                completion(.failure(error))
            } else {
                completion(.success([.mock]))
            }
        }
    }
    
    func load(dealID: String, completion: @escaping (FilesResult) -> Void) {
        DispatchQueue.global().async {
            if let error = self.filesLoaderError {
                completion(.failure(error))
            } else {
                completion(.success(.mock))
            }
        }
    }
    
    func load(dealID: String, completion: @escaping (NotesResult) -> Void) {
        DispatchQueue.global().async {
            if let error = self.notesLoaderError {
                completion(.failure(error))
            } else {
                completion(.success([.mock]))
            }
        }
    }
}

extension DealDetailsModel {
    static let mock = DealDetailsModel(dealDetails: .mock,
                                       tasks: [.mock],
                                       contacts: [.mock],
                                       files: .mock,
                                       notes: [.mock])
}

private extension Result {
    var error: Failure? {
        switch self {
        case let .failure(error):
            return error
        case .success:
            return nil
        }
    }
}
