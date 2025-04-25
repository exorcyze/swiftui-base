//
//  SwiftUIBaseApp.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import SwiftUI

@main
struct SwiftUIBaseApp: App {
    var body: some Scene {
        WindowGroup {
            Route( MainRoute.root )
            //ContentView()
                .task { ProjectInfo.logInfo() }
        }
    }
}
