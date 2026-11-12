import Foundation

struct TaskItem: Identifiable {
    let id: String
    var title: String
    var isDone: Bool = false
}
