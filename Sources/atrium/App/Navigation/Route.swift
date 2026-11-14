enum Route: CaseIterable, Identifiable {
    case today, tasks, calendar, connections

    var id: Self { self }

    private var info: (title: String, symbol: String) {
        switch self {
        case .today: ("Today", "sun.max")
        case .tasks: ("Tasks", "checkmark.circle")
        case .calendar: ("Calendar", "calendar")
        case .connections: ("Connections", "square.stack.3d.down.right")
        }
    }

    var title: String { info.title }
    var symbol: String { info.symbol }
}
