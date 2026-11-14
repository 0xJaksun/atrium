import SwiftUI

struct TaskRow: View {
    let task: TaskItem
    let onToggle: () -> Void
    @State private var hovering: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            CircleCheck(checked: task.isDone, tint: tint, action: onToggle)
            Text(task.title)
                .font(Theme.body)
                .foregroundStyle(task.isDone ? Theme.text3 : Theme.text1)
                .strikethrough(task.isDone, color: Theme.text3)
                .lineLimit(1)
            Spacer(minLength: 12)
            if let listName: String = task.listName {
                Text(listName)
                    .font(Theme.caption)
                    .foregroundStyle(Theme.text3)
                    .lineLimit(1)
            }
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

    private var tint: Color {
        guard let color: RGB = task.listColor else { return Theme.text2 }
        return Color(red: color.red, green: color.green, blue: color.blue)
    }
}
