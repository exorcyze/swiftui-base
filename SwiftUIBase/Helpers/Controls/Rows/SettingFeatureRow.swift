//
//  SettingFeatureRow.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 7/24/25.
//


import SwiftUI

struct SettingFeatureRow: View {
    private var setting: AppStorage<Bool>
    private var settingValue: Bool { setting.wrappedValue }
    private var defaultValue: Bool = false
    var title: String
    var overrideText: String { defaultValue == setting.projectedValue.wrappedValue ? "[Default]" : "[Overridden]" }
    
    init( _ boolValue: Feature.BoolValues ) {
        self.title = boolValue.displayName
        self.setting = AppStorage( wrappedValue: boolValue.defaultValue, boolValue.rawValue )
        defaultValue = boolValue.defaultValue
    }
    init( _ item: SettingItemModel ) {
        if case .toggle( let feature ) = item.type {
            self.title = feature.displayName
            self.setting = AppStorage( wrappedValue: feature.defaultValue, feature.rawValue )
            defaultValue = feature.defaultValue
        }
        else {
            self.title = "Invalid Item"
            self.setting = AppStorage( wrappedValue: false, "" )
            defaultValue = false
        }
    }
    var body: some View {
        VStack( alignment: .leading ) {
            Toggle( title, isOn: setting.projectedValue )
            
            Text( overrideText )
                .font( .footnote )
                .foregroundStyle( .secondary )
                .transition( .push( from: .bottom ) )
        }
    }
}