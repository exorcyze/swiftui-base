//
//  Created by Mike Johnson on 2025.
//

import UIKit

// MARK: - Assiciated Types

enum AppError : LocalizedError {
    case generalError
    case invalidUrl
    case requestFailed
    case invalidResponse
    case invalidResponseStatus
    case decodingError
    case invalidResponseData
    
    /// allows us to pass in error to alert to get title
    ///
    ///     .alert( isPresented: $showError, error: error ) { error in } message: { error in Text( error.failureReason ) }
    var errorDescription: String? { "Network Error" }
    var localizedDescription: String { failureReason }
    
    var failureReason: String {
        switch self {
        case .generalError: "There was a problem fetching data."
        case .invalidUrl: "The URL was not valid."
        case .requestFailed: "The server request failed."
        case .invalidResponse: "Bad response from server."
        case .invalidResponseStatus: "Bad response status from server."
        case .decodingError: "Unable to decode the server response."
        case .invalidResponseData: "Invlaid response data from the server."
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case del = "DELETE"
}

public struct HTTPHeader { public let field, value: String }

// MARK: - Network Manager

final public class NetworkManager {
    static public let shared = NetworkManager()
    private let session = URLSession.shared
    
    private init() {}
    
    /// Performs a network request, and optionally can output the resulting JSON
    ///
    ///     let endpoint = "https://api.endpoint.com/config"
    ///     let request = try URLRequest( .get, url: endpoint )
    ///     let config: ConfigModel = try await network.perform( request )
    public func perform<T: Decodable>( _ request: URLRequest, outputJson: Bool = false ) async throws -> T {
        let basePath = request.url?.path ?? "Unknown"
        print( "\(request.httpMethod ?? "") > \(basePath)", module: .network )
        
        let ( data, response ) = try await session.data( for: request )
        
        if outputJson { prettyPrint( data, for: basePath ) }
        
        guard let response = response as? HTTPURLResponse else { throw AppError.invalidResponse }
        guard (200...299).contains( response.statusCode ) else { return try networkError( .invalidResponseStatus, message: "Status \(response.statusCode)" ) as! T }
        
        do { return try decode( from: data ) as T }
        catch { throw AppError.decodingError }
    }
    
    /// Loads a json file into a model from the project
    ///
    ///     let config: ConfigModel = try network.file( filename: "config" )
    public func file<T:Decodable>( filename: String ) throws -> T {
        guard let url = Bundle.main.url( forResource: filename, withExtension: "json" ) else { return try networkError( .invalidUrl ) as! T }
        let basePath = url.lastPathComponent
        print( "Load File > \(basePath)", module: .network )
        guard let data = try? Data( contentsOf: url ) else { return try networkError( .invalidUrl ) as! T }
        guard let response = try? decode( from: data ) as T else { return try networkError( .invalidUrl ) as! T }
        return response
    }
    
    /// Parse out query items from a URL string
    public static func getQueryItems( from: String ) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let items = from.split( separator: "&" )
        items.forEach {
            let values = $0.split( separator: "=" )
            queryItems.append( URLQueryItem( name: String(values.first ?? ""), value: String(values.last ?? "" ) ) )
        }
        return queryItems
    }
}

    // MARK: - Private
private extension NetworkManager {
    /// Common decoding function to keep call-site clean when performing requests
    func decode<T: Decodable>( from: Data ) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            // only needed if API doesn't conform to standard formats
            //let formatter = DateFormatter()
            //formatter.dateFormat = DateFormat.isoDateTimeZone.rawValue
            //decoder.dateDecodingStrategy = .formatted(formatter)
            
            return try decoder.decode( T.self, from: from )
        }
        catch {
            print( "Decode Error \(T.self): \(error)", module: .networkError, level: .error );
            throw AppError.decodingError
        }
    }
    
    /// The idea is to have a throw loggedError( wrappedError, "Message" ) to have logging + throwing
    /// in one statement. Needs work
    func networkError( _ error: AppError, message: String = "" ) throws {
        let info = message.isEmpty ? error.localizedDescription : message
        print( info, module: .networkError, level: .error )
        throw error
    }
    
    /// Parses items from response headers
    func parseStatus( response: HTTPURLResponse? ) {
        //let mycode = response?.statusCode ?? 999
        //let mytoken: String = getStatusValue( in: response, for: "Token" )
        //let requestId = getStatusValue( in: response, for: "x-amzn-RequestId" )
        //return APIStatus( code: mycode, token: mytoken )
    }

    /// checks the header for variations of the key ( original, uppercased, lowercased )
    func getStatusValue( in response: HTTPURLResponse?, for key: String ) -> String {
        let keys = [ key, key.lowercased(), key.uppercased() ]
        let values = keys.compactMap { response?.allHeaderFields[ $0 ] as? String }
        return values.first ?? ""
    }
    
    /// Outputs json string from data
    func prettyPrint( _ data: Data, for endpoint: String = "" ) {
        let prettyPrint = NSString( data: data, encoding: String.Encoding.utf8.rawValue ) ?? ""
        print( "\(endpoint) JSON Data: \(prettyPrint)", module: .network )
    }
}

// MARK: - URLRequest

public extension URLRequest {
    init( _ method: HTTPMethod = .get, url endpoint: String, query: String = "", headers: [HTTPHeader]? = nil ) throws {
        guard let url = URL( string: endpoint ) else { print( "invalid url", module: .networkError, level: .error ); throw AppError.invalidUrl }
        
        self.init( url: url )
        self.httpMethod = method.rawValue
        self.setValue( "application/json", forHTTPHeaderField: "Content-Type" )
        
        headers?.forEach { self.addValue( $0.value, forHTTPHeaderField: $0.field ) }
    }
    
    func getHeaders( query: String? = nil, body: [String:Any]? = nil ) -> [HTTPHeader] {
        let contentType = body == nil ? "application/json" : "application/x-www-form-urlencoded"
        
        //session.configuration.httpAdditionalHeaders = [ "Authorization": "Bearer \(NetworkAuth.accessToken)" ]
        
        return [
            HTTPHeader( field: "Content-Type", value: contentType ),
            
            HTTPHeader( field: "x-region", value: "us" ),
            HTTPHeader( field: "x-locale", value: "en-us" ),
            //HTTPHeader( field: "Authorization", value: "Bearer \(NetworkAuth.accessToken)" ),
        ]
    }
}



