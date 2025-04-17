//
//  AppIntentsController.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/15/25.
//

import SwiftUI
import AppIntents
import _AppIntents_SwiftUI

// https://www.youtube.com/watch?v=lcgbcCYzkBU&ab_channel=Rebeloper-RebelDeveloper
// In Shortcuts App, look for app, and add an entry, and then can click on to enter field

@Observable
class AppIntentsController {
    static let shared = AppIntentsController()
    
    var focusedField: FocusedField = .none
}

struct FocusTextFieldIntent: AppIntent {
    static var title = LocalizedStringResource( "Focus Text Field" )
    static var description = IntentDescription( stringLiteral: "Enter your credentials" )
    static var openAppWhenRun: Bool = true
    
    @Parameter( title: "Focused Field" ) var focusedField: String
    
    func perform() async throws -> some IntentResult {
        AppIntentsController.shared.focusedField = FocusedField( rawValue: focusedField.lowercased() )!
        return .result()
    }
}

struct AppIntentContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @FocusState private var focusedField: FocusedField?
    
    @AppStorage( "showSiriTip" ) private var showSiriTip: Bool = true
    
    var body: some View {
        VStack {
            SiriTipView( intent: FocusTextFieldIntent(), isVisible: $showSiriTip )
            Spacer()
            TextField( "Email", text: $email )
                .focused( $focusedField, equals: .email )
            SecureField( "Password", text: $password )
                .focused( $focusedField, equals: .password )
        }
        .textFieldStyle( .roundedBorder )
        .padding()
        .onChange( of: AppIntentsController.shared.focusedField ) { _, newValue in
            focusedField = newValue
        }
    }
}
enum FocusedField: String {
    case none, email, password
}
