struct TaskItem: Identifiable, Equatable, Sendable {
    let sourceId: String
    let sourceItemId: String
    var id: String { "\(sourceId):\(sourceItemId)" }

    var title: String
    var isDone: Bool = false
    var listName: String? = nil
    var listColor: RGB? = nil
}

struct RGB: Equatable, Sendable {
    let red: Double
    let green: Double
    let blue: Double
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
