//
//  Created by Mike Johnson on 4/2/25.
//

import SwiftUI

/// Returns a random number of liorem ipsum words in a range.
///
///         Text( .randomWords( min: 2, max 4 ) )
extension String {
    static func randomWords( min: Int, max: Int ) -> String {
        return Mock.randomWords( min: min, max: max )
    }
}

extension StringProtocol {
    var firstUppercased: String { prefix( 1 ).uppercased() + dropFirst() }
}

struct RandomText: View {
    var min: Int
    var max: Int
    var blackout = false
    
    var body: some View {
        Text( verbatim: .randomWords( min: min, max: max ) )
            .privacySensitive( blackout )
            .redacted( reason: .privacy )
    }
}

struct Mock {
    static let lipsum = "Morbi in magna vitae ante sagittis interdum in ut nulla. Aliquam erat volutpat. Nulla sit amet arcu ut dui interdum blandit nec sit amet sapien. Fusce interdum vitae quam convallis dictum. Vivamus tortor nunc, ultrices feugiat laoreet id, fermentum vehicula sem. Praesent porta consequat erat non dictum. Nulla aliquet mi et diam consequat, et venenatis massa gravida. Duis pellentesque tempus lacus, a vulputate lorem accumsan sit amet. Interdum et malesuada fames ac ante ipsum primis in faucibus. Donec aliquet leo sem, sit amet condimentum tellus imperdiet nec. Proin venenatis convallis libero, in tempor metus iaculis vitae. Pellentesque euismod erat nec dolor ullamcorper molestie. Integer purus risus, mattis id semper eget, blandit at nisi. Suspendisse placerat, neque aliquam pulvinar maximus, turpis odio consectetur leo, aliquet elementum quam ante non ipsum. Mauris suscipit urna sit amet feugiat sollicitudin. "
    static func randomWords( min: Int, max: Int ) -> String {
        let count = Int.random( in: min...max )
        let start = Int.random( in: 0...(max-count) )
        let allWords = lipsum.split( separator: " " )
        let wordRange = allWords[ start...(start+count) ];
        return wordRange.joined( separator: " " ).firstUppercased
    }
}

struct MockList: View {
    var body: some View {
        List {
            ForEach( 0..<20 ) { _ in MockCell() }
        }
    }
}

struct MockCell: View {
    var body: some View {
        HStack( alignment: .top, spacing: 12 ) {
            RoundedRectangle( cornerRadius: 12 )
                .frame( width: 80, height: 80 )
                .foregroundStyle( Color.random().gradient.opacity( 0.5 ) )
            VStack( alignment: .leading ) {
                RandomText( min: 1, max: 3 )
                    .font( .headline )
                RandomText( min: 10, max: 20 )
                    .font( .subheadline )
                    .foregroundStyle( .secondary )
            }
        }
    }
}

#Preview( "Random Text" ) {
    VStack( alignment: .leading, spacing: 8 ) {
        RandomText( min: 2, max: 4 ).font( .title )
        RandomText( min: 10, max: 40, blackout: true ).font( .body )
        RandomText( min: 10, max: 40 ).font( .body )
    }
}

#Preview( "Mock List" ) {
    MockList()
}
