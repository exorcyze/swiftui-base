//
//  NavStacks.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/4/25.
//

import SwiftUI

/// The NavStack groupings to be used by the application
///
/// Sample Usages:
///
///     WindowGroup { NavStack( MainNavStack.root ) }
///
///     @Environment( Navigator<LoginNavStack>.self ) private var loginNavStack
///     @Environment( Navigator<MainNavStack>.self ) private var mainNavStack
///
///     Button( "Sign Up" ) { mainNavStack.push( .signUp ) }
///     Button( "Forgot Password" ) { loginNavStack.push( .forgotPassword, type: .fullScreenCover ) }
///     Button( "Login" ) { mainNavStack.push( .login( title: "Login" ), type: .sheet ) }
///
///     Button( "Back" ) { mainNavStack.pop() }
///     Button( "Close" ) { mainNavStack.pop( .fullScreenCover ) }

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
