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

                ForEach(taskStore.notices) { (notice: TaskStore.Notice) in
                    NoticeBanner(message: notice.message) {
                        taskStore.dismiss(notice)
                    }
                }

                if taskStore.tasks.isEmpty {
                    emptyState
                } else {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(taskStore.tasks) { (task: TaskItem) in
                            TaskRow(task: task) {
                                withAnimation(.smooth(duration: 0.2)) { taskStore.toggleDone(task) }
                            }
                            .padding(.horizontal, -8)
                        }
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
        if taskStore.isLoading && taskStore.tasks.isEmpty { return "Updating…" }
        let open: Int = taskStore.tasks.count { !$0.isDone }
        return open == 0 ? "All done" : "\(open) open"
    }

    @ViewBuilder
    private var emptyState: some View {
        if let blocked: TaskStore.Connection = taskStore.connections.first(where: {
            $0.state == .needsAttention(.permission)
        }) {
            ContentUnavailableView {
                Label("Can't see \(blocked.name)", systemImage: "lock")
            } description: {
                Text("Allow Atrium in System Settings, under Privacy & Security.")
            } actions: {
                Button("Open System Settings") {
                    let link: String =
                        "x-apple.systempreferences:com.apple.preference.security?Privacy_Reminders"
                    if let url: URL = URL(string: link) {
                        NSWorkspace.shared.open(url)
                    }
                }
            }
        } else if let offline: TaskStore.Connection = taskStore.connections.first(where: {
            if case .offline = $0.state { true } else { false }
        }) {
            ContentUnavailableView {
                Label("\(offline.name) isn't responding", systemImage: "wifi.slash")
            } actions: {
                Button("Try Again") { taskStore.retry(offline) }
            }
        } else if !taskStore.isLoading {
            ContentUnavailableView("No Tasks", systemImage: "checkmark.circle")
        }
    }
}

struct NoticeBanner: View {
    let message: String
    let dismiss: () -> Void

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundStyle(.orange)
            Text(message)
                .font(Theme.body)
            Spacer()
            Button(action: dismiss) {
                Image(systemName: "xmark")
            }
            .buttonStyle(.plain)
            .foregroundStyle(Theme.text2)
        }
        .padding(10)
        .background(Theme.hover, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
