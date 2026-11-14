import AppKit
import EventKit

extension MacReminders {
    func askForAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            store.requestFullAccessToReminders { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }

    func allReminders() async -> [TaskItem] {
        await withCheckedContinuation { continuation in
            store.fetchReminders(matching: store.predicateForReminders(in: nil)) { found in
                continuation.resume(returning: (found ?? []).map(MacReminders.toTaskItem))
            }
        }
    }

    private static func toTaskItem(_ reminder: EKReminder) -> TaskItem {
        TaskItem(
            sourceId: sourceId,
            sourceItemId: reminder.calendarItemIdentifier,
            title: reminder.title ?? "",
            isDone: reminder.isCompleted,
            listName: reminder.calendar?.title,
            listColor: RGB(reminder.calendar?.color)
        )
    }

    nonisolated func notices(named names: [Notification.Name]) -> AsyncStream<Void> {
        AsyncStream { continuation in
            let listeners: [Task<Void, Never>] = names.map { name in
                Task {
                    for await _ in NotificationCenter.default.notifications(named: name).map({ _ in
                    }) {
                        continuation.yield()
                    }
                }
            }
            continuation.onTermination = { _ in listeners.forEach { $0.cancel() } }
        }
    }
}

extension RGB {
    init?(_ color: NSColor?) {
        guard let color: NSColor = color?.usingColorSpace(.sRGB) else { return nil }
        self.init(
            red: Double(color.redComponent),
            green: Double(color.greenComponent),
            blue: Double(color.blueComponent)
        )
    }
}
