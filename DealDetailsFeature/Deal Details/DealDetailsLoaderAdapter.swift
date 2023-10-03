import Foundation

struct DealDetailsModel: Equatable {
    let dealDetails: DealDetailsLoader.DetailsResult
    let tasks: TasksLoader.TasksResult
    let contacts: ContactsLoader.ContactsResult
    let files: FilesLoader.FilesResult
    let notes: NotesLoader.NotesResult
}

protocol DealDetailsViewLoader {
    func load(dealID: String) async -> DealDetailsModel
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
    
    func load(dealID: String) async -> DealDetailsModel {
        do {
            let detailsResult = await dealDeailsLoader.load(dealID: dealID)
            let tasksResult = await tasksLoader.load(dealID: dealID)
            let contactsResult = await contactsLoader.load(dealID: dealID)
            let filesResult = await filesLoader.load(dealID: dealID)
            let notesResult = await notesLoader.load(dealID: dealID)
            
            return DealDetailsModel(dealDetails: detailsResult,
                                    tasks: tasksResult,
                                    contacts: contactsResult,
                                    files: filesResult,
                                    notes: notesResult)
            
        }
    }
}
