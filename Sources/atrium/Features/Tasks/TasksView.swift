import SwiftUI

struct TasksView: View {
    @Environment(TaskStore.self) private var taskStore: TaskStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Theme.section) {
                Text("Tasks")
                    .font(Theme.title)

                VStack(alignment: .leading, spacing: 2) {
                    ForEach(taskStore.tasks) { (task: TaskItem) in
                        Text(task.title)
                            .font(Theme.body)
                            .foregroundStyle(task.isDone ? Theme.text2 : Theme.text1)
                            .strikethrough(task.isDone)
                            .frame(height: 32)
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
}
