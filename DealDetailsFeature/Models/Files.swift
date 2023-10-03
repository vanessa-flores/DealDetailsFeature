import Foundation

struct Files: Equatable {
    let files: [File]
    let meta: Meta
    
    struct File: Equatable {
        let id: String
        let name: String
    }
    
    struct Meta: Equatable {
        let storageLimit: Int
        let currentStorageUsage: Int
    }
}
