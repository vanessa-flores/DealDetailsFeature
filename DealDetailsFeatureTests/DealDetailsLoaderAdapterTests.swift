import XCTest

@testable import DealDetailsFeature

struct DealDetailsModel: Equatable {
    let dealDetails: DealDetails
    let tasks: [Task]
    let contacts: [Contact]
    let files: Files
    let notes: [Note]
}

protocol DealDetailsViewLoader {
    typealias LoaderResult = Result<DealDetailsModel, Error>
    
    func load(dealID: String, completion: @escaping (LoaderResult) -> Void)
}

protocol DealDetailsLoader {
    typealias DealDetailsResult = Result<DealDetails, Error>
    
    func load(dealID: String, completion: @escaping (DealDetailsResult) -> Void)
}
protocol TasksLoader {
    typealias TasksResult = Result<[Task], Error>
    
    func load(dealID: String, completion: @escaping (TasksResult) -> Void)
}
protocol ContactsLoader {
    typealias ContactsResult = Result<[Contact], Error>
    
    func load(dealID: String, completion: @escaping (ContactsResult) -> Void)
}
protocol FilesLoader {
    typealias FilesResult = Result<Files, Error>
    
    func load(dealID: String, completion: @escaping (FilesResult) -> Void)
}
protocol NotesLoader {
    typealias NotesResult = Result<[Note], Error>
    
    func load(dealID: String, completion: @escaping (NotesResult) -> Void)
}

class DealDetailsLoaderAdapter: DealDetailsViewLoader {
    
    let dealDeailsLoader: DealDetailsLoader
    let tasksLoader: TasksLoader
    let contactsLoader: ContactsLoader
    let filesLoader: FilesLoader
    let notesLoader: NotesLoader
    
    init(dealDeailsLoader: DealDetailsLoader, tasksLoader: TasksLoader, contactsLoader: ContactsLoader, filesLoader: FilesLoader, notesLoader: NotesLoader) {
        self.dealDeailsLoader = dealDeailsLoader
        self.tasksLoader = tasksLoader
        self.contactsLoader = contactsLoader
        self.filesLoader = filesLoader
        self.notesLoader = notesLoader
    }
    
    func load(dealID: String, completion: @escaping (LoaderResult) -> Void) {
        dealDeailsLoader.load(dealID: dealID) { detailsResult in
            self.tasksLoader.load(dealID: dealID) { tasksResult in
                self.contactsLoader.load(dealID: dealID) { contactsResult in
                    self.filesLoader.load(dealID: dealID) { filesResult in
                        if case let .failure(error) = filesResult {
                            return completion(.failure(error))
                        }
                        
                        self.notesLoader.load(dealID: dealID) { notesResult in
                            completion(.success(DealDetailsModel(dealDetails: try! detailsResult.get(),
                                                                 tasks: try! tasksResult.get(),
                                                                 contacts: try! contactsResult.get(),
                                                                 files: try! filesResult.get(),
                                                                 notes: try! notesResult.get())))
                        }
                    }
                }
            }
        }
    }
}

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
}

// MARK: - Helpers

private class LoaderStub: DealDetailsLoader, TasksLoader, ContactsLoader, FilesLoader, NotesLoader {
    var filesLoaderError: NSError?

    func load(dealID: String, completion: @escaping (DealDetailsResult) -> Void) {
        completion(.success(.mock))
    }
    
    func load(dealID: String, completion: @escaping (TasksResult) -> Void) {
        completion(.success([.mock]))
    }
    
    func load(dealID: String, completion: @escaping (ContactsResult) -> Void) {
        completion(.success([.mock]))
    }
    
    func load(dealID: String, completion: @escaping (FilesResult) -> Void) {
        if let error = filesLoaderError {
            completion(.failure(error))
        } else {
            completion(.success(.mock))
        }
    }
    
    func load(dealID: String, completion: @escaping (NotesResult) -> Void) {
        completion(.success([.mock]))
    }
}

extension DealDetailsModel {
    static let mock = DealDetailsModel(dealDetails: .mock,
                                       tasks: [.mock],
                                       contacts: [.mock],
                                       files: .mock,
                                       notes: [.mock])
}

extension DealDetails {
    static let mock = DealDetails()
}

extension Task {
    static let mock = Task()
}

extension Contact {
    static let mock = Contact()
}

extension Files {
    static let mock = Files()
}

extension Note {
    static let mock = Note()
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
