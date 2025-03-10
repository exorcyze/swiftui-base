//
//  View+Preview.swift
//  Created : Mike Johnson, 2020
//

import SwiftUI

/*
#if DEBUG
struct MyView_Preview: PreviewProvider {
    static var previews: some View {
        ReminderRow(
            title: "Write weekly article",
            description: "Think it'll be about Xcode Previews",
            isCompleted: .mock(false)
        )
        .previewComponent()
        //.previewComponentColors()
    }
}
#endif
*/

// extension allows dynamic mocks for SwiftUI previews
// https://www.swiftbysundell.com/articles/getting-the-most-out-of-xcode-previews/

extension Binding {
    static func mock(_ value: Value) -> Self {
        var value = value
        return Binding(get: { value }, set: { value = $0 })
    }
}

extension ColorScheme {
    var previewName: String {
        String(describing: self).capitalized
    }
}

extension ContentSizeCategory {
    static let smallestAndLargest = [allCases.first!, allCases.last!]

    var previewName: String {
        self == Self.smallestAndLargest.first ? "Small" : "Large"
    }
}

extension ForEach where Data.Element: Hashable, ID == Data.Element, Content: View {
    init(values: Data, content: @escaping (Data.Element) -> Content) {
        self.init(values, id: \.self, content: content)
    }
}

// For SwiftUI preview of component

struct ComponentPreviewColors<Component: View>: View {
    var component: Component

    var body: some View {
        ForEach(values: ColorScheme.allCases) { scheme in
            self.component
                .previewLayout(.sizeThatFits)
                .background(Color(UIColor.systemBackground))
                .colorScheme(scheme)
                .previewDisplayName("\(scheme.previewName)")
        }
    }
}
struct ComponentPreview<Component: View>: View {
    var component: Component

    var body: some View {
        ForEach(values: ColorScheme.allCases) { scheme in
            ForEach(values: ContentSizeCategory.smallestAndLargest) { category in
                self.component
                    .previewLayout(.sizeThatFits)
                    .background(Color(UIColor.systemBackground))
                    .colorScheme(scheme)
                    .environment(\.sizeCategory, category)
                    .previewDisplayName(
                        "\(scheme.previewName) + \(category.previewName)"
                    )
            }
        }
    }
}

// For SwiftUI preview of screen

struct ScreenPreview<Screen: View>: View {
    var screen: Screen
    
    var body: some View {
        ForEach(values: deviceNames) { device in
            ForEach(values: ColorScheme.allCases) { scheme in
                NavigationView {
                    self.screen
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                }
                .previewDevice(PreviewDevice(rawValue: device))
                .colorScheme(scheme)
                .previewDisplayName("\(scheme.previewName): \(device)")
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
    }
    
    private var deviceNames: [String] {
        [
            "iPhone 8",
            "iPhone 11",
            "iPhone 11 Pro Max",
            "iPad (7th generation)",
            "iPad Pro (12.9-inch) (4th generation)",
        ]
    }
}



// Convenience API

extension View {
    /// Previews the given view in 4 modes : Light and
    /// lark mode for both smallest and largest size categories
    func previewComponent() -> some View {
        ComponentPreview(component: self)
    }
    /// Previews the given view in light and dark mode
    func previewComponentColors() -> some View {
        ComponentPreviewColors(component: self)
    }
    /// Previews as a screen for given devices
    func previewAsScreen() -> some View {
        ScreenPreview(screen: self)
    }
}

