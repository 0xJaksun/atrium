import SwiftUI

@main
struct AtriumApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate: AppDelegate

    var body: some Scene {
        Window("Atrium", id: "main") {
            MainView()
                .frame(minWidth: 980, minHeight: 640)
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1200, height: 700)
    }
}
