//
//  Created by Mike Johnson, 2025
//


import SwiftUI

struct SettingItemModel: Identifiable {
    let id = UUID()
    var title: String
    var subtitle: String
    var type: DisplayType
    
    enum DisplayType {
        case info
        case display
        case navigation( AnyView )
        case action( ActionType )
        case toggle( Feature.BoolValues )
        case feature( Feature.BoolValues )
        case picker( String, [String] )
    }
    
    enum ActionType {
        case none
        case custom( () -> Void )
    }
}

struct SettingGroupModel: Identifiable {
    let id = UUID()
    var title: String
    var items: [SettingItemModel]
}
