import AppKit
import EventKit

actor MacReminders: TaskSource {
    static let sourceId: String = "mac-reminders"

    nonisolated let id: String = MacReminders.sourceId
    nonisolated let name: String = "Reminders"

    let store: EKEventStore = EKEventStore()

    func fetch() async throws -> [TaskItem] {
        try await ensureAccess()
        return await allReminders()
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
}
