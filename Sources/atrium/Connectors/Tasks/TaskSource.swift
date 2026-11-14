protocol TaskSource: Sendable {
    var id: String { get }
    var name: String { get }

    func fetch() async throws -> [TaskItem]
    func apply(_ change: TaskChange, to task: TaskItem) async throws

    func changes() -> AsyncStream<Void>
}

extension TaskSource {
    func changes() -> AsyncStream<Void> {
        AsyncStream { $0.finish() }
    }
}

enum SourceError: Error, Equatable {
    case needsPermission
    case needsSignIn
    case unavailable(String)
    case notFound
    case readOnly

    var message: String {
        switch self {
        case .needsPermission: "Access isn't allowed."
        case .needsSignIn: "You need to sign in again"
        case .unavailable(let reason): reason
        case .notFound: "It no longer exists."
        case .readOnly: "It cannot be changed."
        }
    }
}
