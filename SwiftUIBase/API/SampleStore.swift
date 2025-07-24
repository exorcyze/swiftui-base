//
//  Created by Mike Johnson, 2025.
//

import SwiftUI

// MARK: - Sample Objects
fileprivate struct PostData : Codable {
    let name : String
    let age : Int
}
struct GithubUser : Decodable {
    let login : String
    let avatarUrl : String
    
    static var empty = GithubUser( login: "", avatarUrl: "" )
}

// MARK: - Sample Calls

class SampleDataStore {
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
    
    func sampleDecode() {
        let json = """
        {"login":"exorcyze","id":840552,"node_id":"MDQ6VXNlcjg0MDU1Mg==","avatar_url":"https://avatars.githubusercontent.com/u/840552?v=4","gravatar_id":"","url":"https://api.github.com/users/exorcyze","html_url":"https://github.com/exorcyze","followers_url":"https://api.github.com/users/exorcyze/followers","following_url":"https://api.github.com/users/exorcyze/following{/other_user}","gists_url":"https://api.github.com/users/exorcyze/gists{/gist_id}","starred_url":"https://api.github.com/users/exorcyze/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/exorcyze/subscriptions","organizations_url":"https://api.github.com/users/exorcyze/orgs","repos_url":"https://api.github.com/users/exorcyze/repos","events_url":"https://api.github.com/users/exorcyze/events{/privacy}","received_events_url":"https://api.github.com/users/exorcyze/received_events","type":"User","user_view_type":"public","site_admin":false,"name":null,"company":null,"blog":"","location":null,"email":null,"hireable":null,"bio":null,"twitter_username":null,"public_repos":3,"public_gists":10,"followers":9,"following":3,"created_at":"2011-06-09T18:01:56Z","updated_at":"2024-07-04T23:58:18Z"}
        """
        do {
            let user = try GithubUser.decode( from: json )
            print( "User: \(user.avatarUrl)")
        } catch { }
    }
}

