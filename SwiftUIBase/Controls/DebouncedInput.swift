//
//  DebouncedInput.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/7/25.
//

import SwiftUI

// https://www.youtube.com/watch?v=89IGcIZrv7Y&ab_channel=Rebeloper-RebelDeveloper
struct DebouncedTestView : View {
    @State private var text: String = ""
    @State private var debouncedText: String = ""
    var body: some View {
        VStack {
            TextField( "Text", text: $text )
                .textFieldStyle( .roundedBorder )
                .debounced( text: $text, debouncedText: $debouncedText, debounceDelay: 1.0 )
            
            Text( debouncedText )
        }
    }
}

class DebouncedViewModel: ObservableObject {
    @Published var userInput: String = ""
}

struct DebouncedModifier: ViewModifier {
    @State private var viewModel = DebouncedViewModel()
    
    @Binding var text: String
    @Binding var debouncedText: String
    let debounceDelay: TimeInterval
    
    func body( content: Content ) -> some View {
        content
            .onReceive( viewModel.$userInput.debounce(for: RunLoop.SchedulerTimeType.Stride( debounceDelay ), scheduler: RunLoop.main ) ) { value in
                debouncedText = value
            }
            .onChange( of: text ) { _, newValue in
                viewModel.userInput = newValue
            }
    }
}

extension View {
    public func debounced( text: Binding<String>, debouncedText: Binding<String>, debounceDelay: TimeInterval = 0.5 ) -> some View {
        modifier( DebouncedModifier( text: text, debouncedText: debouncedText, debounceDelay: debounceDelay ) )
    }
}

#Preview {
    DebouncedTestView()
}
