//
//  Created by Mike Johnson, 2025
//

import SwiftUI

struct SettingInfoRow: View {
    private let item: SettingItemModel
    
    init( _ item: SettingItemModel ) { self.item = item }
    
    var body: some View {
        Text( item.title )
            .font( .footnote )
            .foregroundStyle( .secondary )
    }
}












