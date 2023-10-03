import Foundation

protocol DealDetailsLoader {
    typealias DetailsResult = Result<DealDetails, LoaderError>
    
    func load(dealID: String) async -> DetailsResult
}

protocol TasksLoader {
    typealias TasksResult = Result<[Task], LoaderError>
    
    func load(dealID: String) async -> TasksResult
}

protocol ContactsLoader {
    typealias ContactsResult = Result<[Contact], LoaderError>
    
    func load(dealID: String) async -> ContactsResult
}

protocol FilesLoader {
    typealias FilesResult = Result<Files, LoaderError>
    
    func load(dealID: String) async -> FilesResult
}

protocol NotesLoader {
    typealias NotesResult = Result<[Note], LoaderError>
    
    func load(dealID: String) async -> NotesResult
}

enum LoaderError: Error, Equatable {
    case unloadable
}
