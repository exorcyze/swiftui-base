//
// Created : Mike Johnson, 2020
//

import Foundation

public extension Collection {
    var isNotEmpty: Bool { return !isEmpty }
    var hasElements: Bool { return !isEmpty }
}

public extension String {
    var isNotEmpty: Bool { return !isEmpty }
    var hasCharacters: Bool { return !isEmpty }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range( of: "[^a-zA-Z0-9]", options: .regularExpression ) == nil
    }
    
    static let urlAllowed: CharacterSet = .alphanumerics.union(.init(charactersIn: "-._~")) // as per RFC 3986
    var urlEncoded: String? {
        return addingPercentEncoding( withAllowedCharacters: String.urlAllowed )
    }
}
