//
//  DebugHelper.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/10/25.
//

import UIKit

// TODO: - Possibly combine signatures for setBool and setString. Could
// also extend to base off a typealias to support additional types more easily
// at the potential expense of a bit less clarity at the call-site
// Eg: setValue( for: .key, to: false ) :: var val: Bool = debugValue( for: .key )
// static func setValue( for key: String, to value: DebugOverridable? ) { }
public protocol DebugOverridable {}
extension Bool : DebugOverridable {}
extension String : DebugOverridable {}

public class DebugHelper {

    /// All debug functionality will be based off of this flag being set.
    /// It's set by calling initializeDebugMode() during app startup.
    ///
    /// Project > Target > Build Settings > Active Comiplation Conditions > Debug / Release
    /// For Debug key, enter DEBUG for the value, Release key should be blank.
    ///
    ///     #if DEBUG
    ///     DebugHelper.isDebug = true
    ///     #endif
    public static var isDebug = false

    /// This should be called upon app launch to apply overrides
    /// for things like environment, etc. This will set isDebug to true
    /// in case you want to check in other areas ( Eg for showing a debug panel )
    static func initializeDebugMode() {
        // this could be changed to have value passed in or
        // use #DEBUG conditional internally
        isDebug = true
        
        //print( "Show Auth Splash: \(Feature.isEnabled(.showAuthSplash) )", module: .application )
    }

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
