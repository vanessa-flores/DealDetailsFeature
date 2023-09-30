import Foundation

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


private extension DealDetailsLoaderAdapter {
    
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
}
