import Foundation

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