//
// FeatureFlags
// Created / Copyright © : Mike Johnson, 2022
//

import Foundation

public protocol Defaultable {
    associatedtype DefaultableType
    var defaultValue: DefaultableType { get }
}

public struct Feature {
    public enum BoolValues: String, CaseIterable, Defaultable {
        case showAuthSplash = "showAuthSplash"
        
        public var defaultValue: Bool {
            switch self {
            case .showAuthSplash: return true
            }
        }
        public var value: Bool {
            // If we have a debug override, use that first ( dev + testing )
            if let override = DebugHelper.debugBool( for: self.rawValue ) { return override }
            
            // TODO: Update with remote value
            //let remoteValue: Bool? = getRemoteValue( for: self.rawValue )
            //return remoteValue ?? self.defaultValue
            
            return self.defaultValue
        }
    }
    public enum StringValues: String, CaseIterable, Defaultable {
        case welcomeText = "text.welcome"
        
        public var defaultValue: String { return "none" }
        public var value: String {
            // If we have a debug override, use that first ( dev + testing )
            if let override = DebugHelper.debugString( for: self.rawValue ) { return override }
            // TODO: Update with remote value
            return self.defaultValue
        }
    }
}

// MARK: - Public

public extension Feature {
    static func isEnabled( _ key: BoolValues ) -> Bool {
        return key.value
    }
    static func value( for key: StringValues ) -> String {
        return key.value
    }
}

// MARK: - Private

private extension Feature {
    func test() {
        let bval = Feature.isEnabled( .showAuthSplash )
        let sval = Feature.value( for: .welcomeText )
        print( "\(bval) : \(sval)" )
    }
}
