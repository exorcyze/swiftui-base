//
//  NavStacks.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/4/25.
//

import SwiftUI

enum MainNavStack: Navigable {
    var id: UUID { .init() }
    
    case root
    case login( title: String )
    case signUp
    
    var body: some View {
        switch self {
        case .root: MainView()
        case .login( let title ): NavStack( LoginNavStack.root( title: title ) )
        case .signUp: SignUpView()
        }
    }
}

enum LoginNavStack: Navigable {
    var id: UUID { .init() }
    
    case root( title: String )
    case forgotPassword
    
    var body: some View {
        switch self {
        case .root( let title ): LoginView( title: title )
        case .forgotPassword: ForgotPasswordView()
        }
    }
}

