import Foundation

@testable import DealDetailsFeature

extension DealDetails {
    static let mock = DealDetails(id: "1", name: "Deal 1")
}

extension Task {
    static let mock = Task()
}

extension Contact {
    static let mock = Contact()
}

extension Files {
    static let mock = Files(files: [.mock], meta: .mock)
}

extension Files.File {
    static let mock = Files.File(id: "1", name: "File 1")
}

extension Files.Meta {
    static let mock = Files.Meta(limit: 1024)
}

extension Note {
    static let mock = Note()
}
