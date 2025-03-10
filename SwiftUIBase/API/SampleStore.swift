//
//  SampleStore.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import UIKit

// MARK: - Sample Calls

@MainActor
class SampleDataStore : ObservableObject {
    let network = NetworkManager.shared
    
    func getGithubUser() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/exorcyze"
        return try await network.perform( url: endpoint )
        //let response : GithubUser = try await perform( url: endpoint )
        //return response
    }
    
    func postData() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/exorcyze"
        guard let url = URL( string: endpoint ) else { throw AppError.invalidUrl }
        var request = URLRequest( url: url )
        request.httpMethod = "POST"
        request.setValue( "application/json", forHTTPHeaderField: "Content-Type" )
        
        let postData = PostData( name: "Count Chocula", age: 48 )
        let jsonData = try JSONEncoder().encode(postData)
        request.httpBody = jsonData

        return try await network.perform( request: request )
    }
    struct PostData : Codable {
        let name : String
        let age : Int
    }
    struct GithubUser : Codable {
        let login : String
        let avatarUrl : String
        let bio : String
    }

}

