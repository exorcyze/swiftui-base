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
            //MemoryUsageChart()
            //Route( MainRoute.root )
            //ContentView()
            SettingsView(menuItems: SettingData.debugSettings(), title: "Debug Settings" )
                .environment( appController )
                .task {
                    ProjectInfo.logInfo()
                    do {
                        let user = try await SampleDataStore().getGithubUser()
                        print( "User: \(user.login)")
                        SampleDataStore().sampleDecode()
                    } catch { }
                }
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
        // prints out views when recalculated for debugging
        //let _ = Self._printChanges()
        
        VStack {
            Text( appController.text )
            
            TextField( "Text", text: $appController.text )
                .textFieldStyle( .roundedBorder )
        }
    }
}

// Can use ViewModifier to add access to environment variables
fileprivate struct MyViewModel { func fetchData() { } }
fileprivate struct SampleViewModifier: ViewModifier {
    @Environment var viewModel: MyViewModel
    func body(content: Content) -> some View {
        content
            .onTapGesture { viewModel.fetchData() }
    }
}
