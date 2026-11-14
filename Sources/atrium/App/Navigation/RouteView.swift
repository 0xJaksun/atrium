import SwiftUI

struct RouteView: View {
    let route: Route

    var body: some View {
        switch route {
        case .today: TodayView()
        case .tasks: TasksView()
        case .calendar: CalendarView()
        case .connections: ConnectionsView()
        }
    }
}
