import Foundation
import Observation

@Observable
@MainActor
final class TaskStore {
    struct Connection: Identifiable, Equatable {
        enum State: Equatable {
            case connecting
            case connected
            case offline(String)
            case needsAttention(Attention)
        }

        enum Attention: Equatable {
            case permission
            case signIn
        }

        let id: String
        let name: String
        var state: State = .connecting
        var tasks: [TaskItem] = []
    }

    struct Notice: Identifiable, Equatable {
        let id: UUID = UUID()
        let message: String
    }

    private(set) var tasks: [TaskItem] = []
    private(set) var notices: [Notice] = []
    private(set) var connections: [Connection] {
        didSet { rebuild() }
    }

    var isLoading: Bool {
        connections.contains { $0.state == .connecting }
    }

    private let sources: [String: any TaskSource]
    private var lanes: [String: Task<Void, Never>] = [:]
    private var reloadsWaiting: Set<String> = []
    private var pending: [String: TaskItem] = [:] {
        didSet { rebuild() }
    }

    init(sources: [any TaskSource]) {
        self.sources = Dictionary(sources.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        connections = sources.map { Connection(id: $0.id, name: $0.name) }
        for source: any TaskSource in sources {
            reload(source)
            watch(source)
        }
    }

    func toggleDone(_ task: TaskItem) {
        save(.done(!task.isDone), to: task)
    }

    func refresh() {
        sources.values.forEach(reload)
    }

    func retry(_ connection: Connection) {
        guard let source: any TaskSource = sources[connection.id] else { return }
        reload(source)
    }

    func dismiss(_ notice: Notice) {
        notices.removeAll { $0.id == notice.id }
    }

    private func watch(_ source: any TaskSource) {
        Task { [weak self] in
            for await _ in source.changes() {
                self?.reload(source)
            }
        }
    }

    private func reload(_ source: any TaskSource) {
        guard reloadsWaiting.insert(source.id).inserted else { return }
        enqueue(for: source) {
            self.reloadsWaiting.remove(source.id)
            do {
                let tasks: [TaskItem] = try await source.fetch()
                self.update(source) {
                    $0.tasks = tasks
                    $0.state = .connected
                }
            } catch {
                self.loadFailed(source, error)
            }
        }
    }

    private func loadFailed(_ source: any TaskSource, _ error: Error) {
        guard let attention: Connection.Attention = attention(for: error) else {
            update(source) { $0.state = .offline(self.describe(error)) }
            return
        }
        let wasWorking: Bool = connections.first { $0.id == source.id }?.state == .connected
        update(source) { $0.state = .needsAttention(attention) }
        if wasWorking {
            notify("\(source.name) stopped working and needs your attention.")
        }
    }

    private func save(_ change: TaskChange, to task: TaskItem) {
        guard let source: any TaskSource = sources[task.sourceId] else { return }
        let changed: TaskItem = change.applied(to: task)
        pending[task.id] = changed
        enqueue(for: source) {
            do {
                try await source.apply(change, to: task)
                self.update(source) { connection in
                    guard let index: Int = connection.tasks.firstIndex(where: { $0.id == task.id })
                    else { return }
                    connection.tasks[index] = change.applied(to: connection.tasks[index])
                }
            } catch {
                self.saveFailed(source, task, error)
            }
            if self.pending[task.id] == changed {
                self.pending[task.id] = nil
            }
        }
    }

    private func saveFailed(_ source: any TaskSource, _ task: TaskItem, _ error: Error) {
        notify("Couldn't change “\(task.title)” in \(source.name). \(describe(error))")
        if let attention: Connection.Attention = attention(for: error) {
            update(source) { $0.state = .needsAttention(attention) }
        } else if let failure: SourceError = error as? SourceError, [.notFound, .readOnly].contains(failure) {
            reload(source)
        }
    }

    private func rebuild() {
        let latest: [TaskItem] = connections.flatMap(\.tasks).map { pending[$0.id] ?? $0 }
        if latest != tasks {
            tasks = latest
        }
    }

    private func attention(for error: Error) -> Connection.Attention? {
        switch error as? SourceError {
        case .needsPermission: .permission
        case .needsSignIn: .signIn
        default: nil
        }
    }

    private func describe(_ error: Error) -> String {
        (error as? SourceError)?.message ?? error.localizedDescription
    }

    private func update(_ source: any TaskSource, _ change: (inout Connection) -> Void) {
        guard let index: Int = connections.firstIndex(where: { $0.id == source.id }) else { return }
        change(&connections[index])
    }

    private func notify(_ message: String) {
        notices.append(Notice(message: message))
    }

    private func enqueue(for source: any TaskSource, _ work: @escaping @MainActor () async -> Void) {
        let previous: Task<Void, Never>? = lanes[source.id]
        lanes[source.id] = Task {
            await previous?.value
            await work()
        }
    }
}
