//
//  SwiftUIBaseApp.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import SwiftUI

@main
struct SwiftUIBaseApp: App {

    @State private var appController = AppController()
    
    var body: some Scene {
        WindowGroup {
            Route( MainRoute.root )
            //ContentView()
                .environment( appController )
                .task { ProjectInfo.logInfo() }
        }
    }
}


@Observable
class AppController {
    var text = "Test"
}

struct AppControllerSampleView: View {
    
    @Environment(AppController.self) private var appController
    
    var body: some View {
        // allow us to bind to it
        @Bindable var appController = appController
        
        VStack {
            Text( appController.text )
            
            TextField( "Text", text: $appController.text )
                .textFieldStyle( .roundedBorder )
        }
    }
}
