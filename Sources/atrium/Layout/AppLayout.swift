import SwiftUI

struct AppLayout<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        HStack(spacing: 0) {
            Sidebar()
            Rectangle()
                .fill(Theme.hairline)
                .frame(width: 1)
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.canvas)
        }
        .ignoresSafeArea()
    }
}
