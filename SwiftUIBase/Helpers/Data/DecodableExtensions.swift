//
//  Created by Mike Johnson, 2025.
//

import SwiftUI

public extension Decodable {
    /// Decode instance of decodable model from json data. Useful for mocks and testing
    ///
    ///     let model = try MyModel.decode( from: jsonData )
    static func decode( from: Data ) throws -> Self {
        do {
            return try JSONDecoder.shared.decode( Self.self, from: from )
        }
        catch {
            print( "Decode Error \(Self.self): \(error)", level: .error );
            throw AppError.decodingError
        }
    }
    /// Decode instance of decodable model from json string. Useful for mocks and testing
    ///
    ///     let model = try MyModel.decode( from: jsonString )
    static func decode( from: String ) throws -> Self {
        do {
            let data = from.data( using: .utf8 )
            return try decode( from: data ?? Data() )
        }
        catch {
            throw AppError.decodingError
        }
    }
}
