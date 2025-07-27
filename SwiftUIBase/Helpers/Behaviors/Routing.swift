//
//  Created by Mike Johnson, 2025.
//

import SwiftUI

/// Provides simpler navigation that is more akin to how things can be done in UIKit.
/// See sample code at the bottom of the file for example implementations.
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

// MARK: - Route

/// The type that our enums of pages conform to, allowing them to be used by our Routing / Route
typealias Routable = View & Identifiable & Hashable

/// Used to create a new navigation stack from NavigationStacks enums
///
///     Route( MainRoute.root )
struct Route<NavigationPage: Routable>: View {
    
    let root: NavigationPage
    
    @State private var nav = Routing<NavigationPage>()
    
    init( _ root: NavigationPage ) { self.root = root }
    
    var body: some View {
        NavigationStack( path: $nav.path ) {
            root
                .navigationDestination( for: NavigationPage.self ) { $0 }
                .sheet( item: $nav.sheet ) { $0 }
                .fullScreenCover( item: $nav.fullScreenCover ) { $0 }
        }
        .environment( nav )
    }
}

// MARK: Routing

/// The main Routing is used for the logic in pushing, popping, and presenting views.
@Observable
class Routing<RouteDestination: Routable> {
    
    var path: NavigationPath = NavigationPath()
    var sheet: RouteDestination?
    var fullScreenCover: RouteDestination?
    
    enum PushType {
        case link, sheet, fullScreenCover
    }
    enum PopType {
        case link( last: Int )
        case sheet
        case fullScreenCover
    }
    
    func push( _ page: RouteDestination, type: PushType = .link ) {
        switch type {
        case .link: path.append( page )
        case .sheet: sheet = page
        case .fullScreenCover: fullScreenCover = page
        }
    }
    
    func pop( _ type: PopType = .link( last: 1 ) ) {
        switch type {
        case .link(last: let last): path.removeLast( last )
        case .sheet: sheet = nil
        case .fullScreenCover: fullScreenCover = nil
        }
    }
    
    func popToRoot() {
        path.removeLast( path.count )
    }
}

// MARK: - Sample Route Definitions

fileprivate enum SampleMainRoute: Routable {
    var id: UUID { .init() }
    
    case root
    case login( title: String )
    case signUp
    
    var body: some View {
        switch self {
        case .root: SampleMainView()
        case .login( let title ): Route( SampleLoginRoute.root( title: title ) )
        case .signUp: SampleSignUpView()
        }
    }
}

fileprivate enum SampleLoginRoute: Routable {
    var id: UUID { .init() }
    
    case root( title: String )
    case forgotPassword
    
    var body: some View {
        switch self {
        case .root( let title ): SampleLoginView( title: title )
        case .forgotPassword: SampleForgotPasswordView()
        }
    }
}

// MARK: - Sample Route Usages

//@main
fileprivate struct SampleRoutingAppRoute: App {
    var body: some Scene {
        WindowGroup { Route( SampleMainRoute.root ) }
    }
}
fileprivate struct SampleMainView: View { var body: some View { Text( "Main" ) } }
fileprivate struct SampleLoginView: View {
    var title: String
    var body: some View { Text( "Login" ) }
}
fileprivate struct SampleForgotPasswordView: View {
    @Environment( Routing<SampleMainRoute>.self ) private var mainRoute
    var body: some View {
        List {
            Text( "Forgot Password" )
            Button( "Back" ) { mainRoute.pop( .fullScreenCover ) }
        }
    }
}
fileprivate struct SampleSignUpView: View { var body: some View { Text( "Sign Up" ) } }

