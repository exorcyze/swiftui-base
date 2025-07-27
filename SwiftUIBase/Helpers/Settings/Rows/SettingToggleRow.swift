//
//  Created by Mike Johnson, 2025
//


import SwiftUI

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
    }
}
