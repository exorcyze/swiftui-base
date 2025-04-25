//
//  NavStacks.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/4/25.
//

import SwiftUI

/// The Route groupings to be used by the application
///
/// Sample Usages:
///
///     WindowGroup { Route( MainRoute.root ) }
///
///     @Environment( Routing<LoginRoute>.self ) private var loginRoute
///     @Environment( Routing<MainRoute>.self ) private var mainRoute
///
///     Button( "Sign Up" ) { mainRoute.push( .signUp ) }
///     Button( "Forgot Password" ) { loginRoute.push( .forgotPassword, type: .fullScreenCover ) }
///     Button( "Login" ) { mainRoute.push( .login( title: "Login" ), type: .sheet ) }
///
///     Button( "Back" ) { mainRoute.pop() }
///     Button( "Close" ) { mainRoute.pop( .fullScreenCover ) }

enum MainRoute: Routable {
    var id: UUID { .init() }
    
    case root
    case login( title: String )
    case signUp
    
    var body: some View {
        switch self {
        case .root: MainView()
        case .login( let title ): Route( LoginRoute.root( title: title ) )
        case .signUp: SignUpView()
        }
    }
}

enum LoginRoute: Routable {
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
