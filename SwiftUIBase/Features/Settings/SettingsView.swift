//
// Created by Mike Johnson, 2025.
//

import SwiftUI

// MARK: - Core Views

struct SettingsView: View {
    @State var menuItems: [SettingGroupModel]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach( menuItems ) { section( for: $0 ) }
            }
            .listStyle( .grouped )
            .navigationTitle( "Debug Settings" )
        }
    }
    
    func section( for group: SettingGroupModel ) -> some View {
        Section( group.title ) {
            ForEach( group.items ) { itemCell( $0 ) }
        }
    }

    func itemCell( _ item: SettingItemModel ) -> some View {
        Group {
            switch item.type {
            case .info: SettingInfoRow( item )
            case .navigation: SettingNavigationRow( item )
            case .toggle: SettingToggleRow( item )
            case .feature: SettingFeatureRow( item )
            case .picker: SettingPickerRow( item )
            case .action: SettingActionRow( item, action: onButton )
            case .display: SettingDisplayRow( item )
            }
        }
    }
    
    func onButton( _ item: SettingItemModel ) {
        //print( "Button Clicked: " + item.subtitle )
        if case .action( let actionType ) = item.type {
            switch actionType {
            case .none: return
            case .custom( let action ):
                action()
                return
            }
        }
    }
}

// MARK: - Data Sources

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
            SettingItemModel( title: "Debug Flags", subtitle: "", type: .navigation( SettingsView( menuItems: SettingData.boolFeatureFlags() ).anyView ) ),
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
    SettingsView( menuItems: SettingData.debugSettings() )
}
#Preview( "Features" ) {
    SettingsView( menuItems: SettingData.boolFeatureFlags() )
}

/*
// https://stackoverflow.com/questions/73922720/generic-enum-as-a-parameter-for-a-picker-swiftui-ios
protocol PickerDataSource: CaseIterable where AllCases: RandomAccessCollection, AllCases.Element: Hashable & RawRepresentable & Identifiable, AllCases.Element.RawValue == String {}
struct PickerRow<T: PickerDataSource>: View {
    //private var setting: AppStorage<String>
    //private var settingValue: String { setting.wrappedValue }
    let title: String
    let dataSource: T
    @Binding private var entry: String
    
    init( _ title: String, dataSource: T ) {
        self.title = title
        self.dataSource = dataSource
    }
    
    var body: some View {
        Picker( title, selection: $entry ) {
            ForEach( T.allCases ) { item in
                Text( item.rawValue )
            }
        }
    }
}
*/
