import SwiftUI

enum Theme {
    static let text1: Color = Color.primary
    static let text2: Color = Color.secondary
    static let hairline: Color = Color(nsColor: .separatorColor)

    static let canvas: Color = Color(nsColor: .textBackgroundColor)
    static let hover: Color = Color.primary.opacity(0.05)
    static let selected: Color = Color.primary.opacity(0.09)
    static let accent: Color = Color.accentColor

    static let body: Font = Font.system(size: 13)
    static let bodyStrong: Font = Font.system(size: 13, weight: .semibold)

    static let gutter: CGFloat = 16
    static let topInset: CGFloat = 52

    static let sidebarWidth: CGFloat = 228
    static let rowRadius: CGFloat = 7
}
