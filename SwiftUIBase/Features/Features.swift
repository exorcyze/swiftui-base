//
//  Features.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/9/25.
//

import SwiftUI

/*
// https://colinwren.medium.com/mocking-user-defaults-in-your-swift-unit-tests-54f8a8452dda
class MockFeature: UserDefaults {
    var persisted = [String: Data?]()
    override func set( _ value: Any?, forKey defaultName: String ) { persisted[ defaultName ] = value as? Data }
    override func object( forKey defaultName: String ) -> Any?  { return super.object( forKey: defaultName ) }
}
let feature = Feature( UserDefaults.standard )
let mock = MockFeature()
mock.set( true, forKey: BoolValues.pboV7.rawValue )
let feature = Feature( mock )
// OR
Feature.isEnabled( .pboV7, provider: mock ) // default provider = UserDefaults.standard
*/

struct FeatureViewModel: Identifiable {
    let id = UUID()
    let key: String
    let name: String
    var value: Bool {
        didSet {
            guard let boolKey = Feature.BoolValues( rawValue: key ) else { return }
            Feature.setOverride( value, for: boolKey )
        }
    }
    var hasOverride: Bool

    static func allBoolFeatures() -> [FeatureViewModel] {
        return Feature.BoolValues.allCases.map {
            FeatureViewModel( key: $0.rawValue, name: $0.displayName, value: Feature.isEnabled( $0 ), hasOverride: Feature.hasOverride( for: $0.rawValue ) )
        }
    }
}

struct FeaturesView: View {
    @State var boolData = FeatureViewModel.allBoolFeatures()

    var body: some View {
        List {
            boolFeaturesSection

            Button( "Reset All Overrides", action: resetOverrides )
        }
        .listStyle( .grouped )
    }

    var boolFeaturesSection: some View {
        Section( "Feature Flags" ) {
            ForEach( $boolData ) { $item in
                HStack {
                    boolCellLabels( item: item )
                    Spacer()
                    Toggle( " ", isOn: $item.value )
                }
                .padding( 8 )
                .onTapGesture { item.value.toggle() }
            }
        }
    }

    @ViewBuilder
    func boolCellLabels( item: FeatureViewModel ) -> some View {
        VStack( alignment: .leading ) {
            HStack( alignment: .firstTextBaseline ) {
                Text( item.name )
                Text( item.hasOverride ? "[Override]" : "[Default]" )
                    .font( .footnote )
                    .foregroundStyle( .secondary )
            }
            Text( item.key )
                .font( .footnote )
        }
    }

    func resetOverrides() {
        print( "Reset All Overrides" )
        Feature.removeOverrides()
        boolData = FeatureViewModel.allBoolFeatures()
    }
}

// MARK: - ViewController

class FeaturesController: UIViewController {
    weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let featuresView = UIHostingController( rootView: FeaturesView() )
        addChild( featuresView )
        featuresView.view.frame = container.bounds
        container.addSubview( featuresView.view )
        featuresView.didMove( toParent: self )
    }
}

// MARK: - Protocols

/// Protocol to allow for possibility of having different default values per key
public protocol Featurable: CaseIterable, Hashable {
    associatedtype DefaultableType
    var defaultValue: DefaultableType { get }
    var value: DefaultableType { get }
    var displayName: String { get }
}

public extension Featurable {
    var value: DefaultableType { return self.defaultValue }
    var displayName: String { "\(self)".replacingOccurrences( of: "-", with: " " ).capitalized }
}

// MARK: - Base Implementation

/// Core enums + string key values for Feature Flags
public final class Feature {
    public enum BoolValues: String, Featurable {
        case pboV7 = "wpnx-espn-playback-v7"

        // this can be used to implement different defaults per key if desired
        public var defaultValue: Bool { return false }

        public var displayName: String {
            switch self {
            case .pboV7: "PBO v7"
            }
        }

        public var value: Bool {
            // if we have a debug override, use that
            if let override: Bool = Feature.override( for: self.rawValue ) { return override }

            // try values for weaponx + bootstrap. this is a tad verbose to have extra functions
            // but makes the order of operations more clear, and separated out for easier removal
            // or renaming later, compared to multiple switches inline here.
            if let bootstrap = bootstrapBool( for: self ) {
                if let weaponx = weaponXBool( for: self ) { return weaponx }
                return bootstrap
            }

            // default if nothing else
            return self.defaultValue
        }
    }

    public enum StringValues: String, Featurable {
        case test = "test-key"
    }
}

// MARK: - Public

public extension Feature {
    /// Returns boolean value for a feature flag
    ///
    ///   if Feature.isEnabled( .pboV7 ) { }
    static func isEnabled( _ key: BoolValues ) -> Bool { return key.value }

    /// Returns a string value for a feature flag
    ///
    ///   let value = Feature.value( for: .test )
    static func value( for key: StringValues ) -> String { key.value }

    /// Returns a boolean indicating if we have a local override for a key
    static func hasOverride( for key: String ) -> Bool { return UserDefaults.standard.object( forKey: key ) != nil }

    /// Removes all local override values
    static func removeOverrides() {
        for boolValue in BoolValues.allCases { setOverride( nil, for: boolValue ) }
    }

    /// Sets local override values for a key, for use in QA debug panels
    static func setOverride( _ value: Bool?, for key: BoolValues ) {
        // ignore if we're not in debug mode
        if AppEnvironment.isProduction { return }
        // handle removing the value if nil
        if value == nil {
            UserDefaults.standard.removeObject( forKey: key.rawValue )
            return
        }
        // set our value
        UserDefaults.standard.set( value, forKey: key.rawValue )
    }

}

// MARK: - Private Bool Features

private extension Feature {
    static func override<T>( for key: String ) -> T? {
        if AppEnvironment.isProduction { return nil }
        return UserDefaults.standard.object( forKey: key ) as? T
    }
    
    static func bootstrap<T>( for key: any Featurable ) -> T? {
        //let features = Bootstrap.shared.trackBFeatures
        //switch key {
        //case .pboV7: return features.pbov7Enabled as? T
        //}
        return nil
    }
    static func overrideBool( for key: String ) -> Bool? {
        // ignore if we're not in debug
        if AppEnvironment.isProduction { return nil }
        guard UserDefaults.standard.object( forKey: key ) != nil else { return nil }
        return UserDefaults.standard.bool( forKey: key )
    }

    static func bootstrapBool( for key: BoolValues ) -> Bool? {
        /*
        let features = Bootstrap.shared.trackBFeatures
        switch key {
        case .pboV7: return features.pbov7Enabled
        }
         */
        return nil
    }

    static func weaponXBool( for key: BoolValues ) -> Bool? {
        /*
        let flags = AuthenticationInteractor.shared.coreSDKInteractor.currentFeatureFlags
        switch flags[ key.rawValue ] {
        case .booleanPayload( let value ): return value
        default: return nil
        }
         */
        return nil
    }
}

// MARK: - String Features
// TODO: Implement like above as needed

public extension Feature.StringValues {
    var defaultValue: String { return "" }
}

private extension Feature { }

// MARK: - Preview

#Preview {
    FeaturesView()
}
