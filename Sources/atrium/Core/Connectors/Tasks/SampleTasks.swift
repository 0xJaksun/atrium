actor SampleTasks: TaskSource {
    private static let sourceId: String = "samples"
    private static let blue: RGB = RGB(red: 0.04, green: 0.52, blue: 1.0)
    private static let red: RGB = RGB(red: 1.0, green: 0.27, blue: 0.23)
    private static let green: RGB = RGB(red: 0.2, green: 0.78, blue: 0.35)

    nonisolated let id: String = SampleTasks.sourceId
    nonisolated let name: String = "Samples"

    private var tasks: [TaskItem] = [
        task("1", "Book flights to Melbourne", list: "Travel", blue),
        task("2", "Reply to Sam about Friday", list: "Work", red),
        task("3", "Renew car registration", list: "Personal", green),
        task("4", "Post standup notes", list: "Work", red, isDone: true),
    ]

    func fetch() async throws -> [TaskItem] {
        tasks
    }

    func apply(_ change: TaskChange, to task: TaskItem) async throws {
        guard let index: Int = tasks.firstIndex(where: { $0.id == task.id }) else {
            throw SourceError.notFound
        }
        tasks[index] = change.applied(to: tasks[index])
    }

    private static func task(
        _ itemId: String, _ title: String, list: String, _ color: RGB, isDone: Bool = false
    ) -> TaskItem {
        TaskItem(
            sourceId: sourceId, sourceItemId: itemId, title: title, isDone: isDone,
            listName: list, listColor: color)
    }
}
