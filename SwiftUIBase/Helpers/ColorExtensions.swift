//
//  ColorExtensions.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/10/25.
//

import SwiftUI

extension Color {
    /// Used to catalog brand / app colors
    ///
    ///     let mycolor : Color = .brand.primary
    enum brand {
        static let primary = Color( hex: 0x00633d )
    }
}

extension UIColor {
    /// Use to get a color from a hex value :
    ///
    ///     let mycolor = UIColor( hex: 0x00ff00 )
    convenience init( hex: UInt32, alpha: CGFloat = 1.0 ) {
        let r : CGFloat = ((CGFloat)((hex & 0xFF0000) >> 16))/255.0
        let g : CGFloat = ((CGFloat)((hex & 0xFF00) >> 8))/255.0
        let b : CGFloat = ((CGFloat)(hex & 0xFF))/255.0
        let a : CGFloat = alpha
        self.init( red: r, green: g, blue: b, alpha: a )
    }
}

extension Color {
    /// Use to get a color from a hex value :
    ///
    ///     let mycolor = Color( hex: 0x00ff00 )
    init( hex: UInt32, alpha: CGFloat = 1.0 ) {
        self.init(uiColor: UIColor( hex: hex, alpha: alpha ) )
    }
}

