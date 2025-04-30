//
//  Created by Mike Johnson on 2025.
//

import SwiftUI

// MARK: - Sample Objects
public struct PostData : Codable {
    let name : String
    let age : Int
}
public struct GithubUser : Codable {
    let login : String
    let avatarUrl : String
    
    static var empty = GithubUser( login: "", avatarUrl: "" )
}

// MARK: - Sample Calls

public class SampleDataStore {
    private let network = NetworkManager.shared
    
    func getGithubUser() async throws -> GithubUser {
        let endpoint = "https://api.github.com/users/exorcyze"
        let request = try URLRequest( .get, url: endpoint )
        return try await network.perform( request )
        
        // if additional things needed, such as dealing with a wrapper return packet type
        // that may not match the function return type
        //let response : GithubUserWrapper = try await network.perform( request )
        //return response.user
    }
    
    func postData() async throws -> GithubUser {
        let endpoint = "https://someendpoint.com"
        let postData = PostData( name: "Count Chocula", age: 48 )
        
        var request = try URLRequest( .post, url: endpoint )
        request.httpBody = try JSONEncoder().encode( postData )

        return try await network.perform( request )
    }
    
    func urlBuilding() {
        let baseUrl = URL( string: "http://api.github.com" )!
        let url = baseUrl.appending( components: "users", "exorcyze" )
            .appending( queryItems: [ URLQueryItem( name: "refresh", value: "true" ) ] )
    }
}

