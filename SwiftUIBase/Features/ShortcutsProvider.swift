//
//  ShortcutsProvider.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/15/25.
//

import SwiftUI
import AppIntents

// https://www.youtube.com/watch?v=DCPT7mC6VQE&ab_channel=Rebeloper-RebelDeveloper

struct ShortcutsProvider: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut( intent: FocusTextFieldIntent(), phrases: [ "Focus text field in \(.applicationName)", "Enter credentials in \(.applicationName)" ], shortTitle: "Focus Text Field", systemImageName: "pencil.and.ellipsis.rectangle" )
    }
}

