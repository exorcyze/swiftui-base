//
//  InputFocusedState.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/29/25.
//

import SwiftUI

struct InputFocusedState: View {
    @State var text = ""
    @FocusState var isTyping
    
    var body: some View {
        VStack {
            TextField( "Email", text: $text )
                .padding( .leading )
                .frame( height: 55 )
                .background( .gray.opacity( 0.15 ), in: .rect( cornerRadius: 12 ) )
                .overlay( content: {
                    RoundedRectangle( cornerRadius: 12 )
                        .stroke( lineWidth: 2 )
                        .foregroundStyle( isTyping ? Color.primary : .clear )
                })
                .focused( $isTyping )
        }
        .padding()
    }
}

#Preview {
    InputFocusedState()
}
