//
//  Created by Mike Johnson, 2025
//


import SwiftUI

struct SettingDisplayRow: View {
    private let item: SettingItemModel
    
    init( _ item: SettingItemModel ) { self.item = item }
    
    var body: some View {
        #if os(iOS)
        infoView
        #elseif os(tvOS)
        // use a button with no action to ensure that all items are visible on tvOS,
        // like for cases where you may have a lot of info rows for qa / debugging
        Button {} label: { infoView }
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
