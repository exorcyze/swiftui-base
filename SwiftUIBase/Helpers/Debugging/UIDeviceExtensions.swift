//
// Created : Mike Johnson, 2022
//

import Foundation
import UIKit

public extension UIDevice {
    static var isiPhone : Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    static var isiPad : Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    static var isTv: Bool { return UIDevice.current.userInterfaceIdiom == .tv }
    
    static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    static var isAppleTV4K: Bool {
        // Known Apple TV 4K model identifiers
        // https://en.wikipedia.org/wiki/Apple_TV#Technical_specifications
        let appleTV4KIdentifiers = [
            "AppleTV5,3", // Apple TV HD (4th generation)
            "AppleTV6,2", // Apple TV 4K (1st generation)
            "AppleTV11,1", // Apple TV 4K (2nd generation)
            "AppleTV14,1"  // Apple TV 4K (3rd generation)
        ]
        return appleTV4KIdentifiers.contains(modelIdentifier)
    }
}

