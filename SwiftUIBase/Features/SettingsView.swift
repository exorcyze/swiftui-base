//
//  Created by Mike Johnson, 2025.
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
            case .picker: SettingPickerRow( item )
            case .action: SettingActionRow( item, action: onButton )
            default: SettingDisplayRow( item )
            }
        }
    }
    
    func onButton( _ item: SettingItemModel ) {
        print( "Button Clicked: " + item.subtitle )
        if case .action( let actionType ) = item.type {
            switch actionType {
            case .none: return
            case .clear:
                Feature.removeOverrides()
                SettingData.removeSettingKeyData()
            }
        }
    }
}

// MARK: - Supplementary Views

struct SettingInfoRow: View {
    private let item: SettingItemModel
    
    init( _ item: SettingItemModel ) { self.item = item }
    
    var body: some View {
        #if os(iOS)
        textView
        #elseif os(tvOS)
        Button {} label: { textView }
        #endif
    }
    var textView: some View {
        Text( item.title )
            .font( .footnote )
            .foregroundStyle( .secondary )
    }
}

struct SettingDisplayRow: View {
    private let item: SettingItemModel
    
    init( _ item: SettingItemModel ) { self.item = item }
    
    var body: some View {
        #if os(iOS)
        infoView
        #elseif os(tvOS)
        // use a button with no action to ensure that all items are visible on tvOS
        Button {} label: { infoView }
            .buttonStyle( .borderless )
        #endif
    }
    var infoView: some View {
        VStack( alignment: .leading ) {
            Text.optional( item.title, allowEmpty: false )?
                .font( .footnote )
                .foregroundStyle( .secondary )
            
            Text( item.subtitle )
        }
    }
}

struct SettingNavigationRow: View {
    private let item: SettingItemModel
    
    init( _ item: SettingItemModel ) { self.item = item }
    
    var body: some View {
        if case .navigation( let screen ) = item.type {
            NavigationLink( item.title, destination: screen )
        }
    }
}

struct SettingActionRow: View {
    private let item: SettingItemModel
    private var action: ((SettingItemModel) -> ())?
    
    init( _ item: SettingItemModel, action: ((SettingItemModel) -> ())? ) {
        self.item = item
        self.action = action
    }
    
    var body: some View {
        Button {
            action?( item )
        } label: {
            SettingDisplayRow( item )
        }
    }
}

struct SettingToggleRow: View {
    private var setting: AppStorage<Bool>
    private var settingValue: Bool { setting.wrappedValue }
    var title: String
    
    init( _ boolValue: Feature.BoolValues ) {
        self.title = boolValue.displayName
        self.setting = AppStorage( wrappedValue: boolValue.defaultValue, boolValue.rawValue )
    }
    init( _ item: SettingItemModel ) {
        if case .toggle( let feature ) = item.type {
            self.title = feature.displayName
            self.setting = AppStorage( wrappedValue: feature.defaultValue, feature.rawValue )
        }
        else {
            self.title = "Invalid Item"
            self.setting = AppStorage( wrappedValue: false, "" )
        }
    }
    var body: some View {
        Toggle( title, isOn: setting.projectedValue )
            .tint( .pink )
    }
}

struct SettingPickerRow: View {
    var title: String
    var values: [String] = []
    
    private var setting: AppStorage<String>
    private var settingValue: String { setting.wrappedValue }
    
    init( _ title: String, dataSource: [String], key: String ) {
        self.title = title
        self.values = dataSource
        self.setting = AppStorage( wrappedValue: "", key )
    }
    init( _ item: SettingItemModel ) {
        if case .picker( let key, let items ) = item.type { self.init( item.title, dataSource: items, key: key ) }
        else { self.init( "Invalid", dataSource: [], key: "" ) }
    }
    var body: some View {
        #if os(iOS)
        Picker( selection: setting.projectedValue, label: Text( title ) ) {
            ForEach( values: values ) { Text( $0 ) }
        }
        #elseif os(tvOS)
        Text( "Not implemented for tvOS yet")
        #endif
    }
}

// MARK: - Models

struct SettingGroupModel: Identifiable {
    let id = UUID()
    var title: String
    var items: [SettingItemModel]
}

struct SettingItemModel: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var type: DisplayType
    
    enum DisplayType {
        case info
        case display
        case navigation( AnyView )
        case action( ActionType )
        case toggle( Feature.BoolValues )
        case picker( String, [String] )
    }
    
    enum ActionType {
        case none
        case clear
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
            SettingItemModel( title: "", subtitle: "Clear All Debug Data", type: .action( .clear ) ),
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
            SettingItemModel( title: "", subtitle: "Clear All Debug Data", type: .action( .clear ) ),
        ] ) )

        return ret
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
