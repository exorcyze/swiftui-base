//
//  PopupView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/17/25.
//

import SwiftUI

struct PopupView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Text( "Title" )
                .font( .headline )
            
            Text( "Description goes in here." )
                .font( .subheadline )
            
            Button( "Close" ) { isShowing.toggle() }
        }
        .padding()
        .background( .regularMaterial )
        .clipShape( .rect( cornerRadius: 8 ) )
        .shadow( radius: 8 )
    }
}

struct PopupViewModifier: ViewModifier {
    @Binding var showPopup: Bool
    
    func body( content: Content ) -> some View {
        content
            .overlay( alignment: .center ) {
                if showPopup { PopupView( isShowing: $showPopup ) }
            }
    }
}

extension View {
    func popup( isShowing: Binding<Bool> ) -> some View {
        modifier( PopupViewModifier( showPopup: isShowing ) )
    }
}

struct PopupViewTest: View {
    @State private var showPopup = true
    
    var body: some View {
        ContentUnavailableView( "Placeholder", systemImage: "person.circle", description: Text( "There is no content here" ) )
            .popup( isShowing: $showPopup )
    }
}

#Preview {
    PopupViewTest()
}
