import AppKit
import EventKit

actor MacReminders: TaskSource {
    nonisolated let id: String = "mac-reminders"
    nonisolated let name: String = "Reminders"

    let store: EKEventStore = EKEventStore()

    func fetch() async throws -> [TaskItem] {
        try await ensureAccess()
        return await allReminders().map(toTaskItem)
    }

    func apply(_ change: TaskChange, to task: TaskItem) async throws {
        try await ensureAccess()
        guard
            let reminder: EKReminder = store.calendarItem(withIdentifier: task.sourceItemId)
                as? EKReminder
        else { throw SourceError.notFound }
        guard reminder.calendar.allowsContentModifications else { throw SourceError.readOnly }

        switch change {
        case .done(let done): reminder.isCompleted = done
        }

        do {
            try store.save(reminder, commit: true)
        } catch {
            throw SourceError.unavailable(error.localizedDescription)
        }
    }

    nonisolated func changes() -> AsyncStream<Void> {
        notices(named: [.EKEventStoreChanged, NSApplication.didBecomeActiveNotification])
    }

    private func ensureAccess() async throws {
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .fullAccess: return
        case .notDetermined:
            guard await askForAccess() else { throw SourceError.needsPermission }
        default:
            throw SourceError.needsPermission
        }
    }

    private func toTaskItem(_ reminder: Reminder) -> TaskItem {
        TaskItem(
            sourceId: id,
            sourceItemId: reminder.id,
            title: reminder.title,
            isDone: reminder.isDone
        )
    }
}
