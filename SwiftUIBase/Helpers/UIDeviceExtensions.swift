//
// UIDeviceExtensions
// Created / Copyright © : Mike Johnson, 2022
//

import Foundation
import UIKit

public extension UIDevice {
    static var isiPhone : Bool { return UIDevice.current.userInterfaceIdiom == .phone }
    static var isiPad : Bool { return UIDevice.current.userInterfaceIdiom == .pad }
    static var isTv: Bool { return UIDevice.current.userInterfaceIdiom == .tv }
}

