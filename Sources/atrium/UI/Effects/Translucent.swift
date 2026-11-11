import SwiftUI

struct Translucent: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view: NSVisualEffectView = NSVisualEffectView()
        view.material = .sidebar
        view.blendingMode = .behindWindow
        view.state = .followsWindowActiveState
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

extension View where Self == Translucent {
    static var translucent: Translucent { Translucent() }
}
