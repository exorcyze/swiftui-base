//
//  Created by Mike Johnson 2025.
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

// MARK: - Main Route

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

// MARK: - Login Route

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

// MARK: - Sample Stubs

// Here for illustration above only
fileprivate struct MainView: View { var body: some View { Text( "Main" ) } }
fileprivate struct LoginView: View {
    var title: String
    var body: some View { Text( "Login" ) }
}
fileprivate struct ForgotPasswordView: View { var body: some View { Text( "Forgot" ) } }
fileprivate struct SignUpView: View { var body: some View { Text( "Sign Up" ) } }
