import Observation

@Observable
@MainActor
final class Router {
    var route: Route = .today
}
