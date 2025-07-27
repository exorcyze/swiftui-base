//
// Created by Mike Johnson, 2025
//

import SwiftUI

struct NavigationStackModifier: ViewModifier {
    func body( content: Content ) -> some View {
        NavigationStack { content }
    }
}

extension View {
    /// Used to embed a view in a navigation stack to reduce UI nesting
    /// for standard, simple use-cases
    ///
    ///     VStack { /* ... */ }.embedInNavigationStack()
    func embedInNavigationStack() -> some View {
        modifier( NavigationStackModifier() )
    }
}
