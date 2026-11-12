import EventKit

struct MacReminders {
    enum Failure: Error {
        case accessDenied
    }

    static func fetch() async throws -> [TaskItem] {
        let store: EKEventStore = EKEventStore()
        try await requestAccess(to: store)
        return await allReminders(in: store)
    }

    private static func requestAccess(to store: EKEventStore) async throws {
        guard try await store.requestFullAccessToReminders() else {
            throw Failure.accessDenied
        }
    }

    private static func allReminders(in store: EKEventStore) async -> [TaskItem] {
        await withCheckedContinuation { (continuation: CheckedContinuation<[TaskItem], Never>) in
            store.fetchReminders(matching: store.predicateForReminders(in: nil)) {
                (reminders: [EKReminder]?) in
                continuation.resume(returning: (reminders ?? []).map(toTaskItem))
            }
        }
    }

    private static func toTaskItem(_ reminder: EKReminder) -> TaskItem {
        TaskItem(
            id: reminder.calendarItemIdentifier,
            title: reminder.title ?? "",
            isDone: reminder.isCompleted
        )
    }
}
