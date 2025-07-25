//
//  Created by Mike Johnson, 2025
//

import SwiftUI

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












