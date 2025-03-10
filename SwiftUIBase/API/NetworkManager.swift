//
//  NetworkManager.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import UIKit

enum AppError : Error {
    case generalError
    case invalidUrl
    case invalidResponse
    case invalidResponseStatus
    case decodingError
    case invalidResponseData
}

final class NetworkManager {
    public enum DateFormat: String {
        case isoDate = "yyyy-mm-dd"
        case isoDateTime = "yyyy-MM-dd'T'HH:mm:ss"
        case isoDateTimeZone = "yyyy-MM-dd'T'HH:mm:ss'Z'" // .iso8601
    }

    static let shared = NetworkManager()
    private let session = URLSession.shared
    
    static let baseUrl = "https://seanallen-course-backend.herokuapp.com/swiftui-fundamentals/"
    private let appetizerUrl = baseUrl + "appetizers"
    
    private init() {}
    
    public func perform<T: Decodable>( url endpoint: String ) async throws -> T {
        guard let url = URL( string: endpoint ) else { throw AppError.invalidUrl }
        print( "Network > \(url.path)" )
        
        //session.configuration.httpAdditionalHeaders = [ "Authorization": "Bearer \(NetworkAuth.accessToken)" ]
        
        // can instead build request + do .data( for: request )
        let ( data, response ) = try await session.data( from: url )

        guard let response = response as? HTTPURLResponse else { throw loggedError( AppError.invalidResponse, message: "Invalid Response" ) } //throw AppError.invalidResponse }
        guard response.statusCode == 200 else { throw AppError.invalidResponseStatus }
        
        do { return try decode( from: data ) as T }
        catch { throw AppError.decodingError }
    }
    
    public func perform<T: Decodable>( request: URLRequest ) async throws -> T {
        let ( data, response ) = try await session.data( for: request )

        guard let response = response as? HTTPURLResponse else { throw AppError.invalidResponse }
        guard response.statusCode == 200 else { throw AppError.invalidResponseStatus }
        
        do { return try decode( from: data ) as T }
        catch { throw AppError.decodingError }
    }

    public func getQueryItems( from: String ) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        let items = from.split( separator: "&" )
        items.forEach {
            let values = $0.split( separator: "=" )
            queryItems.append( URLQueryItem( name: String(values.first ?? ""), value: String(values.last ?? "" ) ) )
        }
        return queryItems
    }

    // MARK: - Private
    
    private func decode<T: Decodable>( from: Data ) throws -> T {
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            //let formatter = DateFormatter()
            //formatter.dateFormat = DateFormat.isoDateTimeZone.rawValue
            //decoder.dateDecodingStrategy = .formatted(formatter)
            
            return try decoder.decode( T.self, from: from )
        }
        catch {
            //log( "Decode Error \(T.self): \(error)", type: .networkError );
            throw AppError.decodingError
        }
    }
    
    private func loggedError( _ error: Error, message: String ) -> Error {
        print( "Error: " + message )
        return error
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
}



