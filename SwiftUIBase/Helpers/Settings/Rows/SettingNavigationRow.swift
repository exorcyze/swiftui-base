//
//  Created by Mike Johnson, 2025
//


import SwiftUI

struct SettingNavigationRow: View {
    private let item: SettingItemModel
    
    init( _ item: SettingItemModel ) { self.item = item }
    
    var body: some View {
        if case .navigation( let screen ) = item.type {
            NavigationLink( item.title, destination: screen )
        }
    }
}
