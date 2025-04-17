//
//  DebugView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/10/25.
//

/*
struct TestLink {
    var title: String
    var view: AnyView
}
struct TestLinkView: View {
    let linkItem = TestLink(title: "Test Link", view: AnyView( TestDestinationView() ) )
    
    var body: some View {
        NavigationStack {
            NavigationLink( linkItem.title, destination: linkItem.view )
        }
    }
}
struct TestDestinationView: View {
    var body: some View { Text( "Destination" ) }
}
*/

import SwiftUI

/// Optionally returns a text field based on having a value and potentially not empty
///
///     Text.optional( optionalText, allowEmpty = false )?.font( .headline )
extension Text {
    static func optional(_ text: String?, allowEmpty: Bool = false) -> Text? {
        guard let text else { return nil }
        if !allowEmpty && text.isEmpty { return nil }
        return Text(text)
    }
}

extension View {
    @ViewBuilder
    func hidden( _ hide: Bool, remove: Bool = true ) -> some View {
        if hide {
            if !remove { self.hidden() }
        }
        else { self.transition( .opacity ) }
    }
}


// MARK: - View

struct DebugView: View {
    @State var menuItems: [SettingGroupModel]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach( menuItems ) { group in
                    section( for: group )
                }
            }
            .listStyle( .grouped )
            .navigationTitle( "Debug Settings" )
        }
    }
    
    func section( for group: SettingGroupModel ) -> some View {
        Section( group.title ) {
            ForEach( group.items ) { item in
                itemRow( for: item )
            }
        }
    }
    
    func itemRow( for item: SettingItemModel ) -> some View {
        VStack( alignment: .leading ) {
            if item.type == .disclosure {
                NavigationLink( item.title, destination: item.screen )
            }
            else {
                Text.optional( item.title, allowEmpty: false )?
                    .font( .footnote )
                    .foregroundStyle( .secondary )
                
                Text( item.subtitle )
            }
        }
    }
}

extension DebugView {
    func onItemClicked( item: SettingItemModel ) {
        if case .button = item.type { onButton( item: item ) }
    }
    
    func onButton( item: SettingItemModel ) {
        switch item.action {
        case .none: return
        case .clear: Feature.removeOverrides()
        }
    }
}

// MARK: - Menu Model

struct SettingGroupModel: Identifiable {
    let id = UUID()
    var title: String
    var items: [SettingItemModel]
}

struct SettingItemModel: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var key: String
    var type: DisplayType
    var screen: AnyView
    var action: ActionType = .none
    
    /// Used for DisplayType.button
    enum ActionType {
        case none
        case clear
    }
    
    enum DisplayType {
        case display, disclosure, button
    }
}

extension SettingGroupModel {
    static let emptyView: AnyView = AnyView( EmptyView() )
    
    static func debugSettings() -> [SettingGroupModel] {
        var ret = [SettingGroupModel]()
        
        ret.append( SettingGroupModel( title: "Info", items: [
            SettingItemModel( title: "Version:", subtitle: ProjectInfo.currentVersion, key: "", type: .display, screen: emptyView ),
            SettingItemModel( title: "Device Name:", subtitle: UIDevice.current.name, key: "", type: .display, screen: emptyView ),
            SettingItemModel( title: "Device Model:", subtitle: UIDevice.current.model, key: "", type: .display, screen: emptyView ),
            SettingItemModel( title: "OS Version:", subtitle: UIDevice.current.systemVersion, key: "", type: .display, screen: emptyView ),
        ] ) )

        var environmentName = "No Override"
        //if let envOverride = DebugHelper.debugString( for: DebugHelper.environmentKey ) { environmentName = envOverride }
        ret.append( SettingGroupModel( title: "Environment", items: [
            SettingItemModel( title: environmentName, subtitle: "", key: "", type: .disclosure, screen: emptyView ),
        ] ) )

        //ret.append( DebugMenuModel( title: "Feature Flags", items: boolFeatureFlags() ) )

        ret.append( SettingGroupModel( title: "Features", items: [
            SettingItemModel( title: "Feature Flags", subtitle: "", key: "", type: .disclosure, screen: AnyView( FeaturesView() ) ),
            SettingItemModel( title: "", subtitle: "Clear All Debug Data", key: "", type: .button, screen: emptyView, action: .clear ),
        ] ) )

        return ret
    }
    
    static func boolFeatureFlags() -> [SettingItemModel] {
        var ret = [SettingItemModel]()
        
        Feature.BoolValues.allCases.forEach {
            ret.append( SettingItemModel( title: $0.rawValue, subtitle: "\($0.displayName) : \($0.value)", key: $0.rawValue, type: .display, screen: emptyView ) )
        }
        return ret
    }
}


#Preview {
    DebugView( menuItems: SettingGroupModel.debugSettings() )
}
