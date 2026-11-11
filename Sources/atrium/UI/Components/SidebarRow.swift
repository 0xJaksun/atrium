import SwiftUI

struct SidebarRow: View {
    let title: String
    let symbol: String
    let isSelected: Bool
    let action: () -> Void
    @State private var hovering: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 9) {
                Image(systemName: symbol)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(isSelected ? Theme.accent : Theme.text2)
                    .frame(width: 18)
                Text(title)
                    .font(isSelected ? Theme.bodyStrong : Theme.body)
                Spacer()
            }
            .padding(.horizontal, 9)
            .frame(height: 30)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            isSelected ? Theme.selected : (hovering ? Theme.hover : .clear),
            in: RoundedRectangle(cornerRadius: Theme.rowRadius, style: .continuous)
        )
        .onHover { hovering = $0 }
    }
}
