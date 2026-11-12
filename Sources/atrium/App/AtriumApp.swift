import SwiftUI

@main
struct AtriumApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate: AppDelegate
    @State private var router: Router = Router()
    @State private var taskStore: TaskStore = TaskStore()

    var body: some Scene {
        Window("Atrium", id: "main") {
            AppLayout { RouteView(route: router.route) }
                .environment(router)
                .environment(taskStore)
                .frame(minWidth: 980, minHeight: 640)
                .toolbar { Color.clear }
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: false))
        .defaultSize(width: 1200, height: 700)
    }
}
