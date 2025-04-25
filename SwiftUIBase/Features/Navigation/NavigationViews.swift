//
//  NavigationViews.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/3/25.
//

import SwiftUI

//@main
struct NavigationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            Route( MainRoute.root )
        }
    }
}


struct ForgotPasswordView: View {
    @Environment( Routing<MainRoute>.self ) private var mainRoute
    var body: some View {
        List {
            Text( "Forgot Password" )
            Button( "Back" ) { mainRoute.pop( .fullScreenCover ) }
        }
    }
}

struct LoginView: View {
    var title: String // sample to illustrate passing data

    @Environment( Routing<LoginRoute>.self ) private var loginRoute
    @Environment( Routing<MainRoute>.self ) private var mainRoute

    var body: some View {
        List {
            Button( "Forgot Password" ) { loginRoute.push( .forgotPassword, type: .fullScreenCover ) }
            Button( "Back" ) { mainRoute.pop( .sheet ) }
        }
        .navigationTitle( title )
    }
}

struct MainView: View {
    @Environment( Routing<MainRoute>.self ) private var mainRoute
    
    var body: some View {
        List {
            Button( "Sign Up" ) { mainRoute.push( .signUp ) }
            Button( "Login" ) { mainRoute.push( .login( title: "Login" ), type: .sheet ) }
        }
        .navigationTitle( "Main View" )
    }
}

struct SignUpView: View {
    var body: some View {
        Text( "Sign Up View" )
    }
}
