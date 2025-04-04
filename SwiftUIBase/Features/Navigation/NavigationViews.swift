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
            NavStack( MainNavStack.root )
        }
    }
}


struct ForgotPasswordView: View {
    @Environment( Navigator<MainNavStack>.self ) private var mainNavStack
    var body: some View {
        List {
            Text( "Forgot Password" )
            Button( "Back" ) { mainNavStack.pop( .fullScreenCover ) }
        }
    }
}

struct LoginView: View {
    var title: String // sample to illustrate passing data

    @Environment( Navigator<LoginNavStack>.self ) private var loginNavStack
    @Environment( Navigator<MainNavStack>.self ) private var mainNavStack

    var body: some View {
        List {
            Button( "Forgot Password" ) { loginNavStack.push( .forgotPassword, type: .fullScreenCover ) }
            Button( "Back" ) { mainNavStack.pop( .sheet ) }
        }
        .navigationTitle( title )
    }
}

struct MainView: View {
    @Environment( Navigator<MainNavStack>.self ) private var mainNavStack
    
    var body: some View {
        List {
            Button( "Sign Up" ) { mainNavStack.push( .signUp ) }
            Button( "Login" ) { mainNavStack.push( .login( title: "Login" ), type: .sheet ) }
        }
        .navigationTitle( "Main View" )
    }
}

struct SignUpView: View {
    var body: some View {
        Text( "Sign Up View" )
    }
}
