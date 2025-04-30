//
//  OnAppearOnce.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/29/25.
//

import SwiftUI

struct OnAppearOnce: ViewModifier {
    @State private var didAppear = false
    let perform: () -> Void
    
    func body( content: Content ) -> some View {
        content.onAppear {
            if didAppear { return }
            self.didAppear = true
            self.perform()
        }
    }
}

extension View {
    /// Will only fire once on first appearance
    ///
    ///     .onAppearOnce { setInitialFocusState() }
    public func onAppearOnce( perform: @escaping () -> Void ) -> some View {
        self.modifier( OnAppearOnce( perform: perform ) )
    }
}
