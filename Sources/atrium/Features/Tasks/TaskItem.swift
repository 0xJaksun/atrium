struct TaskItem: Identifiable, Equatable, Sendable {
    let sourceId: String
    let sourceItemId: String
    var id: String { "\(sourceId):\(sourceItemId)" }

    var title: String
    var isDone: Bool = false
}

enum TaskChange: Equatable, Sendable {
    case done(Bool)

    func applied(to task: TaskItem) -> TaskItem {
        var task: TaskItem = task
        switch self {
        case .done(let done): task.isDone = done
        }
        return task
    }
}
