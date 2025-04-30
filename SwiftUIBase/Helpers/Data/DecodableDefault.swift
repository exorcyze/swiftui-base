//
//  Created : Mike Johnson, 2020
//

import Foundation

// Source: https://www.swiftbysundell.com/tips/default-decoding-values/
//
// Usage:
/*
struct Article: Decodable {
    var title: String
    @DecodableDefault.EmptyString var body: String
    @DecodableDefault.False var isFeatured: Bool
    @DecodableDefault.True var isActive: Bool
    @DecodableDefault.EmptyList var comments: [Comment]
    @DecodableDefault.EmptyMap var flags: [String : Bool]
}
*/

// Generic protocol for default value sources
public protocol DecodableDefaultSource {
    associatedtype Value: Decodable
    static var defaultValue: Value { get }
}

/// Decodable type with default values for model values:
///     @DecodableDefault.True var isActive: Bool
public enum DecodableDefault {}

// Generic property wrapper for providing a default value
public extension DecodableDefault {
    @propertyWrapper
    struct Wrapper<Source: DecodableDefaultSource> {
        public typealias Value = Source.Value
        public var wrappedValue = Source.defaultValue
        public init() {}
    }
}

// Make the wrapper conform to decodable
extension DecodableDefault.Wrapper: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        wrappedValue = try container.decode(Value.self)
    }
}

// Add a decoding container specific to the new type
public extension KeyedDecodingContainer {
    func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type, forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
        try decodeIfPresent(type, forKey: key) ?? .init()
    }
}

/// Implement some default value sources
public extension DecodableDefault {
    typealias Source = DecodableDefaultSource
    typealias List = Decodable & ExpressibleByArrayLiteral
    typealias Map = Decodable & ExpressibleByDictionaryLiteral

    enum Sources {
        public enum True: Source { public static var defaultValue: Bool { true } }

        public enum False: Source { public static var defaultValue: Bool { false } }

        public enum EmptyString: Source { public static var defaultValue: String { "" } }
        
        // Conforming to literal protocol instead of concrete type like Array
        public enum EmptyList<T: List>: Source { public static var defaultValue: T { [] } }

        // Conforming to literal protocol instead of concrete type like Dictionary
        public enum EmptyMap<T: Map>: Source { public static var defaultValue: T { [:] } }
        
        public enum Zero: Source { public static var defaultValue: Int { 0 } }
        
        public enum ZeroFloat: Source { public static var defaultValue: Float { 0.0 } }
    }
}

// Now make some nice aliases to reference the above
public extension DecodableDefault {
    typealias True = Wrapper<Sources.True>
    typealias False = Wrapper<Sources.False>
    typealias EmptyString = Wrapper<Sources.EmptyString>
    typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
    typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
    typealias Zero = Wrapper<Sources.Zero>
    typealias ZeroFloat = Wrapper<Sources.ZeroFloat>
}

// Make the property wrapper also conform to common protocols
// if it's wrapped type does
extension DecodableDefault.Wrapper: Equatable where Value: Equatable {}
extension DecodableDefault.Wrapper: Hashable where Value: Hashable {}
extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}

