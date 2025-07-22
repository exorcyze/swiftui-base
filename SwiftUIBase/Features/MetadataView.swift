//
//  MetadataView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson, 2025
//

import SwiftUI

struct MetadataView: View {
    let items = ["2000", "Drama", "Animation", "Musicals", "Horror", "Action" ]
    var body: some View {
        ViewThatFits( in: .horizontal ) {
            ForEach(combinedMetadata.combinedIterations(), id: \.self) { iteration in
                Text(iteration)
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }

    let year: String? = "2005"
    let genres = ["Drama", "Animation", "Musicals", "Horror", "Action" ]
    var combinedMetadata: [String] { return ([year] + genres).compactMap { $0 } }
}

public extension Array where Element == String {
    /// Combines an array of strings into iterative combos using a separator, then reverses that.
    /// Used in combination with ViewThatFits to determine the longest combination that will fit
    /// in a given space.
    ///
    ///     sampleReturn = [ "One • Two • Three", "One • Two", "One" ]
    func combinedIterations( with separator: String = " • " ) -> [String] {
        var combos = [String]()
        for (index, _) in self.enumerated() {
            combos.append( self.prefix( index ).joined( separator: separator ) )
        }
        return combos.reversed()
    }
}

#Preview {
    MetadataView()
}
