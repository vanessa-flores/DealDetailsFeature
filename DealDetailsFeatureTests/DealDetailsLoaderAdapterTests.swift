import XCTest

@testable import DealDetailsFeature

struct DealDetailsModel {
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

class DealDetailsLoaderAdapter {
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
}

final class DealDetailsLoaderAdapterTests: XCTestCase {

    func test() {
        let loader = LoaderStub()
        let sut = DealDetailsLoaderAdapter(dealDeailsLoader: loader, 
                                           tasksLoader: loader,
                                           contactsLoader: loader,
                                           filesLoader: loader,
                                           notesLoader: loader)
        
        
    }
    
    // MARK: - Helpers
    
    private class LoaderStub: DealDetailsLoader, TasksLoader, ContactsLoader, FilesLoader, NotesLoader {
        
        func load(dealID: String, completion: @escaping (DealDetailsResult) -> Void) {
            
        }
        
        func load(dealID: String, completion: @escaping (TasksResult) -> Void) {
            
        }
        
        func load(dealID: String, completion: @escaping (ContactsResult) -> Void) {
            
        }
        
        func load(dealID: String, completion: @escaping (FilesResult) -> Void) {
            
        }
        
        func load(dealID: String, completion: @escaping (NotesResult) -> Void) {
            
        }
    }

}
