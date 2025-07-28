//
// Created by Mike Johnson, 2025
//


import SwiftUI

struct SettingData {
    
    enum AppEnvironment: String, CaseIterable, Identifiable {
        case QA, preprod, prod
        var id: Self { return self }
    }
    
    enum SettingStorageKey: String, CaseIterable {
        case debugEnvironment
    }
    
    static func clearAllData() {
        Feature.removeOverrides()
        SettingData.removeSettingKeyData()
    }
    
    static func removeSettingKeyData() {
        for key in SettingData.SettingStorageKey.allCases {
            UserDefaults.standard.removeObject( forKey: key.rawValue )
        }
    }
    
    static func debugSettings() -> [SettingGroupModel] {
        var ret = [SettingGroupModel]()
        
        ret.append( SettingGroupModel( title: "Info", items: [
            SettingItemModel( title: "Version:", subtitle: ProjectInfo.currentVersion, type: .display ),
            SettingItemModel( title: "Device Name:", subtitle: UIDevice.current.name, type: .display ),
            SettingItemModel( title: "Device Model:", subtitle: UIDevice.current.model, type: .display ),
            SettingItemModel( title: "OS Version:", subtitle: UIDevice.current.systemVersion, type: .display ),
        ] ) )
        
        ret.append( SettingGroupModel( title: "Environment", items: [
            SettingItemModel( title: "Environment", subtitle: "", type: .picker( SettingStorageKey.debugEnvironment.rawValue, AppEnvironment.allCases.map { $0.rawValue } ) ),
            SettingItemModel( title: "Note: Changing environment requires an app restart to take effect.", subtitle: "", type: .info ),
        ] ) )
        
        ret.append( SettingGroupModel( title: "Features", items: [
            SettingItemModel( title: "Debug Flags", subtitle: "", type: .navigation( SettingsView( menuItems: SettingData.boolFeatureFlags(), title: "Feature Flags" ).anyView ) ),
            SettingItemModel( title: "", subtitle: "Clear All Debug Data", type: .action( .custom( clearAllData ) ) ),
            SettingItemModel( title: "", subtitle: "Closure Sample", type: .action( .custom( testOutput ) ) ),
        ] ) )
        
        return ret
    }
    
    static func boolFeatureFlags() -> [SettingGroupModel] {
        var ret = [SettingGroupModel]()
        
        var items = [SettingItemModel]()
        Feature.BoolValues.allCases.forEach {
            items.append( SettingItemModel( title: "", subtitle: "", type: .toggle($0) ) )
        }
        ret.append( SettingGroupModel( title: "Feature Flags", items: items ) )

        ret.append( SettingGroupModel( title: "", items: [
            SettingItemModel( title: "", subtitle: "Clear All Debug Data", type: .action( .custom( Feature.removeOverrides ) ) ),
        ] ) )

        return ret
    }
    
    static func testOutput() {
        print( "Test Output" )
    }
}

// MARK: - Preview

#Preview( "Debug Screen" ) {
    SettingsView( menuItems: SettingData.debugSettings(), title: "Debug Settings" )
}
#Preview( "Features" ) {
    SettingsView( menuItems: SettingData.boolFeatureFlags(), title: "Feature Flags" )
}
