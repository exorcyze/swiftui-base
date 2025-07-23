//
//  Created by Mike Johnson, 2025
//

import SwiftUI

/// Optionally returns a text field based on having a value and potentially not empty
///
///     Text.optional( optionalText, allowEmpty = false )?.font( .headline )
extension Text {
    static func optional(_ text: String?, allowEmpty: Bool = false) -> Text? {
        guard let text else { return nil }
        if !allowEmpty && text.isEmpty { return nil }
        return Text(text)
    }
}
