import SwiftUI

struct TasksView: View {
    @Environment(TaskStore.self) private var taskStore: TaskStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.section) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Tasks")
                        .font(Theme.title)
                    Text(summary)
                        .font(Theme.body)
                        .foregroundStyle(Theme.text2)
                }

                VStack(alignment: .leading, spacing: 2) {
                    ForEach(taskStore.tasks) { (task: TaskItem) in
                        TaskRow(task: task) {
                            withAnimation(.smooth(duration: 0.2)) { taskStore.toggleDone(task) }
                        }
                        .padding(.horizontal, -8)
                    }
                }
            }
            .frame(maxWidth: 720, alignment: .leading)
            .padding(.horizontal, Theme.margin)
            .padding(.top, Theme.topInset + 12)
            .padding(.bottom, Theme.margin)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var summary: String {
        let open: Int = taskStore.tasks.count { !$0.isDone }
        return open == 0 ? "All done" : "\(open) open"
    }
}
