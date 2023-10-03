import Foundation

@testable import DealDetailsFeature

extension DealDetails {
    static let mock = DealDetails(id: "1", name: "Deal 1")
}

extension Task {
    static let mock = Task(id: "1", name: "Task 1")
}

extension Contact {
    static let mock = Contact(id: "1", name: "First Last", email: "any@email.com")
}

extension Files {
    static let mock = Files(files: [.mock], meta: .mock)
}

extension Files.File {
    static let mock = Files.File(id: "1", name: "File 1")
}

extension Files.Meta {
    static let mock = Files.Meta(storageLimit: 10000, currentStorageUsage: 1024)
}

extension Note {
    static let mock = Note(id: "1", description: "Note description")
}
