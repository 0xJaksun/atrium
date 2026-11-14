actor SampleTasks: TaskSource {
    private static let sourceId: String = "samples"

    nonisolated let id: String = SampleTasks.sourceId
    nonisolated let name: String = "Samples"

    private var tasks: [TaskItem] = [
        TaskItem(sourceId: sourceId, sourceItemId: "1", title: "Book flights to Melbourne"),
        TaskItem(sourceId: sourceId, sourceItemId: "2", title: "Reply to Sam about Friday"),
        TaskItem(sourceId: sourceId, sourceItemId: "3", title: "Renew car registration"),
        TaskItem(sourceId: sourceId, sourceItemId: "4", title: "Post standup notes", isDone: true),
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
}
