//
// Created by Mike Johnson, 2025
//

import Foundation

public extension JSONDecoder {
    /// Returns a decoder with the settings used for the project set by default
    ///
    ///     let model = try JSONDecoder.shared.decode( MyModel.self, from: data )
    static var shared: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // only needed if API doesn't conform to standard formats
        //let formatter = DateFormatter()
        //formatter.dateFormat = DateFormat.isoDateTimeZone.rawValue
        //decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }
}
