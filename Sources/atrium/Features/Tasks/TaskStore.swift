import Observation

@Observable
@MainActor
final class TaskStore {
    private static let samples: [TaskItem] = [
        TaskItem(id: "1", title: "Book flights to Melbourne"),
        TaskItem(id: "2", title: "Reply to Sam about Friday"),
        TaskItem(id: "3", title: "Renew car registration"),
        TaskItem(id: "4", title: "Post standup notes", isDone: true),
    ]

    private(set) var tasks: [TaskItem] = samples

    init() {
        Task { await load() }
    }

    func load() async {
        let reminders: [TaskItem] = (try? await MacReminders.fetch()) ?? []
        tasks = Self.samples + reminders
    }

    func toggleDone(_ task: TaskItem) {
        guard let index: Array<TaskItem>.Index = tasks.firstIndex(where: { $0.id == task.id })
        else { return }
        tasks[index].isDone.toggle()
    }
}
