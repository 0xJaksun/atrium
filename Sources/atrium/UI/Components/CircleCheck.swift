import SwiftUI

struct CircleCheck: View {
    let checked: Bool
    var tint: Color = Theme.text2
    let action: () -> Void
    @State private var hovering: Bool = false

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .strokeBorder(
                        checked ? Color.clear : tint.opacity(hovering ? 1 : 0.7), lineWidth: 1.5
                    )
                    .background(
                        Circle().fill(
                            checked ? Theme.text3 : (hovering ? tint.opacity(0.15) : .clear)))
                if checked || hovering {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(checked ? Theme.canvas : tint)
                }
            }
            .frame(width: 16, height: 16)
            .padding(4)
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
    }
}
