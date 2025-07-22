//
//  MoreTextView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/28/25.
//

import SwiftUI

struct DemoView: View {
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items, id: \.self) { item in
                        Text(item)
                            .lineLimit(1)
                            .fixedSize()
                            .overlay(
                                GeometryReader { geometry in
                                    Color.white
                                        .opacity(
                                            geometry.frame(in: .global).maxX < UIScreen.main.bounds.width ? 0.0 : 1.0
                                        )
                                }
                            )
                    }
                }
            }
        }
    }
    
}
struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        DemoView(items: ["2000", "• Drama", "• Animation", "• Musicals", "• Horror", "• Action" ] )
    }
}
    
struct MoreTextView: View {
    let short = "Lorem Ipsum is simply dummy"
    let mid = "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
    let lorem = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."

    @State private var isOverflowed = false
    
    var body: some View {
        VStack( alignment: .leading ) {
            TruncatedText( text: .randomWords( min: 5, max: 40 ), lineLimit: 3 )
                .padding( 16 )
                .background( .gray.opacity( 0.2 ) )

            OverflowText( text: lorem, lineLimit: 3, isOverflowed: $isOverflowed )
                .padding( 16 )
                .background( .gray.opacity( 0.2 ) )
            
            OptionalText( "First" )?.textCase( .uppercase )
            OptionalText( nil )?.textCase( .uppercase )
            OptionalText( "" )?.textCase( .uppercase )
            OptionalText( "Fourth" )?.textCase( .uppercase )
            
        }
    }
    
    func nonOp() { }
    
    func OptionalText( _ text: String? ) -> Text? {
        // if empty isn't a requirement, can use just:
        // return text.map { Text( $0 ) }
        guard let text = text else { return nil }
        return text.isEmpty ? nil : Text( text )
    }
}

/// Determines if text is truncated using onAppear / onChange. Potentially unreliable 100%?
///
///     TruncatedText( text: lorem, lineLimit: 3 )
struct TruncatedText: View {
    let text: String
    let lineLimit: Int
    
    @State private var isTruncated: Bool? = nil
    
    var body: some View {
        VStack( alignment: .leading ) {
            Text( text )
                .lineLimit( lineLimit )
                .background( calculateTruncation() )
            
            if isTruncated == true {
                HStack {
                    Spacer()
                    Text( "More..." )
                }
            }
        }
        .multilineTextAlignment( .leading )
        .onChange( of: text ) { isTruncated = nil }
    }
    
    func calculateTruncation() -> some View {
        ViewThatFits( in: .vertical ) {
            Text( text )
                .hidden()
                .onAppear {
                    guard isTruncated == nil else { return }
                    isTruncated = false
                }
            Color.clear
                .hidden()
                .onAppear {
                    guard isTruncated == nil else { return }
                    isTruncated = true
                }
        }
    }
    
}

/// Encapsulates functionality for overflow text using overflow view modifier
///
///     OverflowText( text: lorem, lineLimit: 3, isOverflowed: $isOverflowed )
struct OverflowText: View {
    let text: String
    let lineLimit: Int
    @Binding var isOverflowed: Bool

    var body: some View {
        Button( action: onMore, label: textBody )
            .buttonStyle( .plain )
    }
    
    func textBody() -> some View {
        VStack( alignment: .leading ) {
            Text( text )
                .lineLimit( lineLimit )
                .overflowed( text, $isOverflowed )
            
            if isOverflowed {
                HStack {
                    Spacer()
                    Text( "More..." )
                }
            }
        }
    }
    
    func onMore() {
        print( "Clicked" )
    }
}

/// View modifier to determine if text is overflowed / truncated using ViewThatFits and
/// notifying with a preference key.
///
///     Text( someLongText )
///         .lineLimit( 3 )
///         .overflowed( someLongText, $isOverflowed )
struct OverflowModifier: ViewModifier {
    let text: String
    @Binding var isOverflowed: Bool
    
    func body( content: Content ) -> some View {
        content
            .background(
                ViewThatFits( in: .vertical ) {
                    Text( self.text )
                        .hidden()
                        .preference(key: OverflowPreferenceKey.self, value: false )
                    Color.clear
                        .preference( key: OverflowPreferenceKey.self, value: true )
                }
            )
            .onPreferenceChange( OverflowPreferenceKey.self ) { isTruncated in self.isOverflowed = isTruncated }
    }
    
    struct OverflowPreferenceKey: PreferenceKey {
        static let defaultValue: Bool = false
        static func reduce( value: inout Bool, nextValue: () -> Bool ) { value = nextValue() }
    }
}
extension View {
    public func overflowed( _ text: String, _ isOverflowed: Binding<Bool> ) -> some View {
        ModifiedContent( content: self, modifier: OverflowModifier( text: text, isOverflowed: isOverflowed ) )
    }
}

#Preview {
    MoreTextView()
}
