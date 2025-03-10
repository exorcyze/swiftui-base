//
//  ContentView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import SwiftUI
import Observation

@Observable
final class SampleViewModel : ObservableObject {
    var firstName : String
    var lastName : String
    init( firstName: String, lastName: String ) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

struct ContentView: View {
    var body: some View {
        var viewModel = SampleViewModel( firstName: "Bilbo", lastName: "" )
        
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")

            /*
            Group {
                TextInputField( "First Name", text: viewModel.firstName )
                    .clearButtonHidden()
                    .isRequired( false )
                    .padding( 16 )
                TextInputField( "Last Name", text: viewModel.lastName )
                    .isRequired()
                    .padding( 16 )
            }
             */
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
