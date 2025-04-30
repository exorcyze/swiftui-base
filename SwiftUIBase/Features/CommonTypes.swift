//
//  Created by Mike Johnson on 2025.
//

import SwiftUI

fileprivate struct Email {
    let wrappedString: String
    init?( _ rawString: String ) {
        //guard rawString.matches( "##regex##" ) else { return nil }
        guard rawString.count > 8 else { return nil }
        wrappedString = rawString
    }
}

fileprivate struct Password {
    let wrappedString: String
    init?( _ rawString: String ) {
        guard rawString.count > 8 else { return nil }
        wrappedString = rawString
    }
}

fileprivate struct PhoneNumber {
    let wrappedString: String
    init?( _ rawString: String ) {
        guard rawString.count == 10 else { return nil }
        wrappedString = rawString
    }
}
