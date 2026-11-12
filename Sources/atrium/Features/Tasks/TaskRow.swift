import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void
    @State private var hovering: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            CircleCheck(checked: task.isDone, action: onToggle)
            Text(task.title)
                .font(Theme.body)
                .foregroundStyle(task.isDone ? Theme.text3 : Theme.text1)
                .strikethrough(task.isDone, color: Theme.text3)
                .lineLimit(1)
            Spacer()
        }
        .padding(.leading, 4)
        .padding(.trailing, 8)
        .frame(height: 32)
        .background(
            hovering ? Theme.hover : .clear,
            in: RoundedRectangle(cornerRadius: Theme.rowRadius, style: .continuous)
        )
        .onHover { hovering = $0 }
    }
}
