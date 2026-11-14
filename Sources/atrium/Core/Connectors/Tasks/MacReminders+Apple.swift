import EventKit

struct Reminder: Sendable {
    let id: String
    let title: String
    let isDone: Bool
}

extension MacReminders {
    func askForAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            store.requestFullAccessToReminders { granted, _ in
                continuation.resume(returning: granted)
            }
        }
    }

    func allReminders() async -> [Reminder] {
        await withCheckedContinuation { continuation in
            store.fetchReminders(matching: store.predicateForReminders(in: nil)) { found in
                let reminders: [Reminder] = (found ?? []).map {
                    Reminder(
                        id: $0.calendarItemIdentifier, title: $0.title ?? "", isDone: $0.isCompleted
                    )
                }
                continuation.resume(returning: reminders)
            }
        }
    }

    nonisolated func notices(named names: [Notification.Name]) -> AsyncStream<Void> {
        AsyncStream { continuation in
            let listeners: [Task<Void, Never>] = names.map { name in
                Task {
                    for await _ in NotificationCenter.default.notifications(named: name).map({ _ in
                        })
                    {
                        continuation.yield()
                    }
                }
            }
            continuation.onTermination = { _ in listeners.forEach { $0.cancel() } }
        }
    }
}
