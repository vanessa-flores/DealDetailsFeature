import XCTest

@testable import DealDetailsFeature

final class DealDetailsLoaderAdapterTests: XCTestCase {

    func test_Load_producesCombinedSuccessfulLoaderResults() async {
        let detailsLoaderStub = DetailsLoaderStub(result: .success(.mock))
        let tasksLoaderStub = TasksLoaderStub(result: .success([.mock]))
        let contactsLoaderStub = ContactsLoaderStub(result: .success([.mock]))
        let filesLoaderStub = FilesLoaderStub(result: .success(.mock))
        let notesLoaderStub = NotesLoaderStub(result: .success([.mock]))
        
        let sut = makeSUT(dealDeailsLoader: detailsLoaderStub,
                          tasksLoader: tasksLoaderStub,
                          contactsLoader: contactsLoaderStub,
                          filesLoader: filesLoaderStub,
                          notesLoader: notesLoaderStub)
        
        let result = await sut.load(dealID: "1")
        
        XCTAssertEqual(result, .mockSuccess)
    }
    
    func test_load_failsWithDetailsLoaderError() async {
        let detailsLoaderStub = DetailsLoaderStub(result: .failure(loaderError()))
        let tasksLoaderStub = TasksLoaderStub(result: .success([.mock]))
        let contactsLoaderStub = ContactsLoaderStub(result: .success([.mock]))
        let filesLoaderStub = FilesLoaderStub(result: .success(.mock))
        let notesLoaderStub = NotesLoaderStub(result: .success([.mock]))
        
        let sut = makeSUT(dealDeailsLoader: detailsLoaderStub,
                          tasksLoader: tasksLoaderStub,
                          contactsLoader: contactsLoaderStub,
                          filesLoader: filesLoaderStub,
                          notesLoader: notesLoaderStub)
        
        let result = await sut.load(dealID: "1")
        
        XCTAssertEqual(result, .mockFailedDetails)
    }
    
    func test_load_failsWithTasksLoaderError() async {
        let detailsLoaderStub = DetailsLoaderStub(result: .success(.mock))
        let tasksLoaderStub = TasksLoaderStub(result: .failure(loaderError()))
        let contactsLoaderStub = ContactsLoaderStub(result: .success([.mock]))
        let filesLoaderStub = FilesLoaderStub(result: .success(.mock))
        let notesLoaderStub = NotesLoaderStub(result: .success([.mock]))
        
        let sut = makeSUT(dealDeailsLoader: detailsLoaderStub,
                          tasksLoader: tasksLoaderStub,
                          contactsLoader: contactsLoaderStub,
                          filesLoader: filesLoaderStub,
                          notesLoader: notesLoaderStub)
        
        let result = await sut.load(dealID: "1")
        
        XCTAssertEqual(result, .mockFailedTasks)
    }
    
    func test_load_failsWithContactsLoaderError() async {
        let detailsLoaderStub = DetailsLoaderStub(result: .success(.mock))
        let tasksLoaderStub = TasksLoaderStub(result: .success([.mock]))
        let contactsLoaderStub = ContactsLoaderStub(result: .failure(loaderError()))
        let filesLoaderStub = FilesLoaderStub(result: .success(.mock))
        let notesLoaderStub = NotesLoaderStub(result: .success([.mock]))
        
        let sut = makeSUT(dealDeailsLoader: detailsLoaderStub,
                          tasksLoader: tasksLoaderStub,
                          contactsLoader: contactsLoaderStub,
                          filesLoader: filesLoaderStub,
                          notesLoader: notesLoaderStub)
        
        let result = await sut.load(dealID: "1")
        
        XCTAssertEqual(result, .mockFailedContacts)
    }
    
    func test_load_failsWithFilesLoaderError() async {
        let detailsLoaderStub = DetailsLoaderStub(result: .success(.mock))
        let tasksLoaderStub = TasksLoaderStub(result: .success([.mock]))
        let contactsLoaderStub = ContactsLoaderStub(result: .success([.mock]))
        let filesLoaderStub = FilesLoaderStub(result: .failure(loaderError()))
        let notesLoaderStub = NotesLoaderStub(result: .success([.mock]))
        
        let sut = makeSUT(dealDeailsLoader: detailsLoaderStub,
                          tasksLoader: tasksLoaderStub,
                          contactsLoader: contactsLoaderStub,
                          filesLoader: filesLoaderStub,
                          notesLoader: notesLoaderStub)
        
        let result = await sut.load(dealID: "1")
        
        XCTAssertEqual(result, .mockFailedFiles)
    }
    
    func test_load_failsWithNotesLoaderError() async {
        let detailsLoaderStub = DetailsLoaderStub(result: .success(.mock))
        let tasksLoaderStub = TasksLoaderStub(result: .success([.mock]))
        let contactsLoaderStub = ContactsLoaderStub(result: .success([.mock]))
        let filesLoaderStub = FilesLoaderStub(result: .success(.mock))
        let notesLoaderStub = NotesLoaderStub(result: .failure(loaderError()))
        
        let sut = makeSUT(dealDeailsLoader: detailsLoaderStub,
                          tasksLoader: tasksLoaderStub,
                          contactsLoader: contactsLoaderStub,
                          filesLoader: filesLoaderStub,
                          notesLoader: notesLoaderStub)
        
        let result = await sut.load(dealID: "1")
        
        XCTAssertEqual(result, .mockFailedNotes)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(dealDeailsLoader: DealDetailsLoader, 
                         tasksLoader: TasksLoader,
                         contactsLoader: ContactsLoader,
                         filesLoader: FilesLoader,
                         notesLoader: NotesLoader) -> DealDetailsLoaderAdapter {
        return DealDetailsLoaderAdapter(dealDeailsLoader: dealDeailsLoader, 
                                        tasksLoader: tasksLoader,
                                        contactsLoader: contactsLoader,
                                        filesLoader: filesLoader,
                                        notesLoader: notesLoader)
    }
    
    private class DetailsLoaderStub: DealDetailsLoader {
        let result: DetailsResult
        
        init(result: DetailsResult) {
            self.result = result
        }
        
        func load(dealID: String) async -> DetailsResult {
            return result
        }
    }
    
    private class TasksLoaderStub: TasksLoader {
        let result: TasksResult
        
        init(result: TasksResult) {
            self.result = result
        }
        
        func load(dealID: String) async -> TasksResult {
            return result
        }
    }
    
    private class ContactsLoaderStub: ContactsLoader {
        let result: ContactsResult
        
        init(result: ContactsResult) {
            self.result = result
        }
        
        func load(dealID: String) async -> ContactsResult {
            return result
        }
    }
    
    private class FilesLoaderStub: FilesLoader {
        let result: FilesResult
        
        init(result: FilesResult) {
            self.result = result
        }
        
        func load(dealID: String) async -> FilesResult {
            return result
        }
    }
    
    private class NotesLoaderStub: NotesLoader {
        let result: NotesResult
        
        init(result: NotesResult) {
            self.result = result
        }
        
        func load(dealID: String) async -> NotesResult {
            return result
        }
    }
}

// MARK: - Mocks

extension DealDetailsModel {
    static let mockSuccess = DealDetailsModel(dealDetails: .success(.mock),
                                              tasks: .success([.mock]),
                                              contacts: .success([.mock]),
                                              files: .success(.mock),
                                              notes: .success([.mock]))
    
    static let mockFailedDetails = DealDetailsModel(dealDetails: .failure(loaderError()),
                                                    tasks: .success([.mock]),
                                                    contacts: .success([.mock]),
                                                    files: .success(.mock),
                                                    notes: .success([.mock]))
    
    static let mockFailedTasks = DealDetailsModel(dealDetails: .success(.mock),
                                                  tasks: .failure(loaderError()),
                                                  contacts: .success([.mock]),
                                                  files: .success(.mock),
                                                  notes: .success([.mock]))
    
    static let mockFailedContacts = DealDetailsModel(dealDetails: .success(.mock),
                                                     tasks: .success([.mock]),
                                                     contacts: .failure(loaderError()),
                                                     files: .success(.mock),
                                                     notes: .success([.mock]))
    
    static let mockFailedFiles = DealDetailsModel(dealDetails: .success(.mock),
                                                     tasks: .success([.mock]),
                                                     contacts: .success([.mock]),
                                                     files: .failure(loaderError()),
                                                     notes: .success([.mock]))
    
    static let mockFailedNotes = DealDetailsModel(dealDetails: .success(.mock),
                                                     tasks: .success([.mock]),
                                                     contacts: .success([.mock]),
                                                     files: .success(.mock),
                                                     notes: .failure(loaderError()))
}

private func loaderError() -> LoaderError {
    .unloadable
}
