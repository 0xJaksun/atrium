import Foundation

struct TaskItem: Identifiable {
    let id: UUID = UUID()
    var title: String
    var isDone: Bool = false
}
