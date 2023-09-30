import XCTest

@testable import DealDetailsFeature

class DealDetailsLoaderAdapter: DealDetailsViewLoader {
    
    let dealDeailsLoader: DealDetailsLoader
    let tasksLoader: TasksLoader
    let contactsLoader: ContactsLoader
    let filesLoader: FilesLoader
    let notesLoader: NotesLoader
    private let queue = DispatchQueue(label: "DealDetailsLoaderAdapter.queue")
    
    init(dealDeailsLoader: DealDetailsLoader, tasksLoader: TasksLoader, contactsLoader: ContactsLoader, filesLoader: FilesLoader, notesLoader: NotesLoader) {
        self.dealDeailsLoader = dealDeailsLoader
        self.tasksLoader = tasksLoader
        self.contactsLoader = contactsLoader
        self.filesLoader = filesLoader
        self.notesLoader = notesLoader
    }
    
    struct PartialResult {
        var dealDetails: DealDetails? {
            didSet { checkCompletion() }
        }
        
        var tasks: [Task]? {
            didSet { checkCompletion() }
        }
        
        var contacts: [Contact]? {
            didSet { checkCompletion() }
        }
        
        var files: Files? {
            didSet { checkCompletion() }
        }
        
        var notes: [Note]? {
            didSet { checkCompletion() }
        }
        
        var error: Error?  {
            didSet { checkCompletion() }
        }
        
        var completion: ((DealDetailsViewLoader.LoaderResult) -> Void)?
        
        private mutating func checkCompletion() {
            if let error = error {
                completion?(.failure(error))
                completion = nil
            } else if let dealDetails = dealDetails, let tasks = tasks, let contacts = contacts, let files = files, let notes = notes {
                completion?(.success(DealDetailsModel(dealDetails: dealDetails,
                                                      tasks: tasks,
                                                      contacts: contacts,
                                                      files: files,
                                                      notes: notes)))
                completion = nil
            }
        }
    }
    
    func load(dealID: String, completion: @escaping (LoaderResult) -> Void) {
        var partialResult = PartialResult(completion: completion)
        
        dealDeailsLoader.load(dealID: dealID) { detailsResult in
            self.queue.sync {
                switch detailsResult {
                case .success(let value):
                    partialResult.dealDetails = value
                case .failure(let error):
                    partialResult.error = error
                }
            }
        }
        
        tasksLoader.load(dealID: dealID) { tasksResult in
            self.queue.sync {
                switch tasksResult {
                case .success(let value):
                    partialResult.tasks = value
                case .failure(let error):
                    partialResult.error = error
                }
            }
        }
        
        contactsLoader.load(dealID: dealID) { contactsResult in
            self.queue.sync {
                switch contactsResult {
                case .success(let value):
                    partialResult.contacts = value
                case .failure(let error):
                    partialResult.error = error
                }
            }
        }
        
        filesLoader.load(dealID: dealID) { filesResult in
            self.queue.sync {
                switch filesResult {
                case .success(let value):
                    partialResult.files = value
                case .failure(let error):
                    partialResult.error = error
                }
            }
        }
        
        notesLoader.load(dealID: dealID) { notesResult in
            self.queue.sync {
                switch notesResult {
                case .success(let value):
                    partialResult.notes = value
                case .failure(let error):
                    partialResult.error = error
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
