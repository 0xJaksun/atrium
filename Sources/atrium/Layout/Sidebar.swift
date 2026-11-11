import SwiftUI

struct Sidebar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(Route.allCases) { (route: Route) in
                SidebarLink(route: route)
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.top, Theme.topInset)
        .frame(width: Theme.sidebarWidth)
        .background(.translucent)
    }
}

struct SidebarLink: View {
    @Environment(Navigation.self) private var navigation: Navigation
    let route: Route

    var body: some View {
        SidebarRow(
            title: route.title,
            symbol: route.symbol,
            isSelected: navigation.route == route
        ) {
            navigation.route = route
        }
    }
}
