import Observation

@Observable
@MainActor
final class TaskStore {
    private(set) var tasks: [TaskItem] = [
        TaskItem(title: "Book flights to Melbourne"),
        TaskItem(title: "Reply to Sam about Friday"),
        TaskItem(title: "Renew car registration"),
        TaskItem(title: "Post standup notes", isDone: true),
    ]

    func toggleDone(_ task: TaskItem) {
        guard let index: Array<TaskItem>.Index = tasks.firstIndex(where: { $0.id == task.id })
        else { return }
        tasks[index].isDone.toggle()
    }
}
