//
//  Created by Mike Johnson, 2025
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

// MARK: - Preview

#Preview( "Debug Screen" ) {
    SettingsView( menuItems: SettingData.debugSettings() )
}
#Preview( "Features" ) {
    SettingsView( menuItems: SettingData.boolFeatureFlags() )
}
