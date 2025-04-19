//
//  ViewExtensions.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/19/25.
//

import SwiftUI

extension View {
    /// Has the option to remove the view if hidden so it is not calculated for layout
    /// and sets an opacity transition on visibility
    @ViewBuilder
    func hidden( _ hide: Bool, remove: Bool = true ) -> some View {
        if hide {
            if !remove { self.hidden() }
        }
        else { self.transition( .opacity ) }
    }
}
