//
//  Created by Mike Johnson on 3/10/25.
//

import UIKit
import os

// TODO: - Possibly combine signatures for setBool and setString. Could
// also extend to base off a typealias to support additional types more easily
// at the potential expense of a bit less clarity at the call-site
// Eg: setValue( for: .key, to: false ) :: var val: Bool = debugValue( for: .key )
// static func setValue( for key: String, to value: DebugOverridable? ) { }
public protocol DebugOverridable {}
extension Bool : DebugOverridable {}
extension String : DebugOverridable {}

public class DebugHelper {

    public enum Environment: String { case production, development }
    /// Returns the envinroment we are running in
    public static var environment: Environment {
        #if DEBUG
        return .development
        #elseif targetEnvironment(simulator)
        return .development
        #else
        guard let path = Bundle.main.appStoreReceiptURL?.path else { return .production }
        return path.contains( "sandboxReceipt" ) ? .development : .production
        #endif
    }
    public static var isProduction: Bool { return environment == .production }
    public static var isDebug: Bool { return environment == .development }

    /// Used to determine if we are previewing in Xcode
    public static var isRunningForPreviews: Bool { ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" }

    /// Clear out all of our local / debug overrides
    static func clearAllDebugData() {
        //setDebugEnvironment( nil )
        for feature in Feature.BoolValues.allCases { setBool(for: feature.rawValue, to: nil ) }
        for feature in Feature.StringValues.allCases { setString(for: feature.rawValue, to: nil ) }
    }
    
    /// Returns a boolean value for a feature key if it exists. If not in debug mode or
    /// if no override value is present locally, then return nil
    static func debugBool( for key: String ) -> Bool? {
        // leave if not in debug mode
        guard isDebug else { return nil }
        
        guard UserDefaults.standard.object( forKey: key ) != nil else { return nil }
        return UserDefaults.standard.bool( forKey: key )
    }
    
    /// Sets or clears a value for a feature key if we are in debug mode. Will clear the
    /// key if the passed value is nil
    static func setBool( for key: String, to value: Bool? ) {
        // leave if not in debug mode
        guard isDebug else { return }
        
        if value == nil {
            UserDefaults.standard.removeObject( forKey: key )
            return
        }
        
        UserDefaults.standard.set( value, forKey: key )
    }
    
    /// Returns a string value for a feature key if it exists. If not in debug mode or
    /// if no override value is present locally, then return nil
    static func debugString( for key: String ) -> String? {
        // leave if not in debug mode
        guard isDebug else { return nil }
        
        guard UserDefaults.standard.object( forKey: key ) != nil else { return nil }
        return UserDefaults.standard.string( forKey: key )
    }
    
    /// Sets or clears a value for a feature key if we are in debug mode. Will clear the
    /// key if the passed value is nil
    static func setString( for key: String, to value: String? ) {
        // leave if not in debug mode
        guard isDebug else { return }
        
        if value == nil {
            UserDefaults.standard.removeObject( forKey: key )
            return
        }
        
        UserDefaults.standard.set( value, forKey: key )
    }

}
