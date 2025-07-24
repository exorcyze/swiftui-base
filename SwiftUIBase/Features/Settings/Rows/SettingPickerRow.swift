//
//  SettingPickerRow.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 7/24/25.
//


import SwiftUI

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