//
//  TypeDrivenLogin.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/23/25.
//

// https://www.youtube.com/watch?v=cCZ00b_RNyc&ab_channel=SwiftCraft

import UIKit

fileprivate class TypeDrivenLogin {
    let emailText = UITextField()
    let passText = UITextField()
    
    func signInTapped() {
        guard let email = Email( emailText.text ?? "" ) else { return }
        guard let pass = Password( passText.text ?? "" ) else { return }
        signIn( email: email, pass: pass )
    }
    func signIn( email: Email, pass: Password ) {
        //AuthService.signIn( email: email.wrappedString, pass: pass.wrappedString ) { }
        AuthService.signIn( email: email, pass: pass ) { (result: Result<AuthUser, Error>) in
            switch result {
            case let .success(user): let main = MainScreen(user)
            case let .failure(error): print( "error" )
            }
        }
    }
}

fileprivate struct Email {
    let wrappedString: String
    init?( _ rawString: String ) {
        //guard rawString.matches( "##regex##" ) else { return nil }
        guard rawString.count > 8 else { return nil }
        wrappedString = rawString
    }
}

fileprivate struct Password {
    let wrappedString: String
    init?( _ rawString: String ) {
        guard rawString.count > 8 else { return nil }
        wrappedString = rawString
    }
}

fileprivate class AuthService {
    //static func signIn( email: String, pass: String, completion: @escaping (Bool) -> Void ) { }
    static func signIn( email: Email, pass: Password, completion: @escaping (Result<AuthUser, Error>) -> Void ) { }
}

fileprivate struct AnonUser { let userID: String }
fileprivate struct AuthUser {
    let userID: String
    let username: String
    let token: String
}

fileprivate enum User {
    case anonymous( AnonUser )
    case signedIn( AuthUser )
}

fileprivate class MainScreen {
    // not used but indicates a requirement for showing the screen
    init( _: AuthUser ) { }
}
