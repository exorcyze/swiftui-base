//
//  SettingActionRow.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 7/24/25.
//


import SwiftUI

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