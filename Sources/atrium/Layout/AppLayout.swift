import SwiftUI

struct AppLayout: View {
    @Environment(Navigation.self) private var navigation: Navigation

    var body: some View {
        HStack(spacing: 0) {
            Sidebar()
            Rectangle()
                .fill(Theme.hairline)
                .frame(width: 1)
            Text(navigation.route.title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Theme.canvas)
        }
        .ignoresSafeArea()
    }
}
