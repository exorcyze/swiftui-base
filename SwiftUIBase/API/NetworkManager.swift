//
//  NetworkManager.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import UIKit

// MARK: - Assiciated Types

enum AppError : Error {
    case generalError
    case invalidUrl
    case invalidResponse
    case invalidResponseStatus
    case decodingError
    case invalidResponseData
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case del = "DELETE"
}

public struct HTTPHeader {
    public let field: String
    public let value: String
}

// MARK: - Network Manager

final public class NetworkManager {
    static public let shared = NetworkManager()
    private let session = URLSession.shared
    
    private init() {}
    
    public func perform<T: Decodable>( _ request: URLRequest, outputJson: Bool = false ) async throws -> T {
        let basePath = request.url?.path ?? "Unknown"
        print( "Network > \(basePath)", type: .network )
        
        let ( data, response ) = try await session.data( for: request )
        
        if outputJson { prettyPrint( data, for: basePath ) }

        guard let response = response as? HTTPURLResponse else { throw AppError.invalidResponse }
        guard response.statusCode == 200 else { throw AppError.invalidResponseStatus }
        
        do { return try decode( from: data ) as T }
        catch { throw AppError.decodingError }
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

    // MARK: - Private
    
    /// Common decoding function to keep call-site clean when performing requests
    private func decode<T: Decodable>( from: Data ) throws -> T {
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
            print( "Decode Error \(T.self): \(error)", type: .networkError );
            throw AppError.decodingError
        }
    }
    
    /// The idea is to have a throw loggedError( wrappedError, "Message" ) to have logging + throwing
    /// in one statement. Needs work
    private func loggedError( _ error: Error, message: String ) throws {
        print( "Error: " + message, type: .networkError )
        throw error
    }
    
    /// Parses items from response headers
    private func parseStatus( response: HTTPURLResponse? ) {
        //let mycode = response?.statusCode ?? 999
        //let mytoken: String = getStatusValue( in: response, for: "Token" )
        //let requestId = getStatusValue( in: response, for: "x-amzn-RequestId" )
        //return APIStatus( code: mycode, token: mytoken )
    }
    /// checks the header for variations of the key ( original, uppercased, lowercased )
    private func getStatusValue( in response: HTTPURLResponse?, for key: String ) -> String {
        let keys = [ key, key.lowercased(), key.uppercased() ]
        let values = keys.compactMap { response?.allHeaderFields[ $0 ] as? String }
        return values.first ?? ""
    }
    
    private func prettyPrint( _ data: Data, for endpoint: String = "" ) {
        let prettyPrint = NSString( data: data, encoding: String.Encoding.utf8.rawValue ) ?? ""
        print( "\(endpoint) JSON Data: \(prettyPrint)", type: .network )
    }
}

// MARK: - URLRequest

public extension URLRequest {
    init( _ method: HTTPMethod = .get, url endpoint: String, query: String = "", headers: [HTTPHeader]? = nil ) throws {
        guard let url = URL( string: endpoint ) else { throw AppError.invalidUrl }
        
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



