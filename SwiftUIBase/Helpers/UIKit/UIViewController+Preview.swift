//
//  Created : Mike Johnson, 2020
//

import Foundation
import UIKit
import SwiftUI

// Source: https://www.swiftbysundell.com/articles/getting-the-most-out-of-xcode-previews/
//
// ViewController Usage:
/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#Preview { MyController().asSwiftUIView() }
#endif
*/

// View Usage:
/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI
#Preview { MyView().asPreview() }
#endif
*/

// MARK: - UIViewController extensions

extension UIViewController {
    private struct SwiftUIController: UIViewControllerRepresentable {
        var viewController: UIViewController
        func makeUIViewController(context: Context) -> UIViewController { viewController }
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    }
    /// Used to generically wrap a UIViewController in a SwiftUI View. Can also be used in previews
    ///
    ///     let view = MyController().asSwiftUIView()
    func asSwiftUIView() -> some View {
        SwiftUIController(viewController: self)
    }
}

// MARK: - UIView Extensions

extension UIView {
    private struct SwiftUIView: UIViewRepresentable {
        var view: UIView
        func makeUIView(context: Context) -> UIView { view }
        func updateUIView(_ view: UIView, context: Context) { }
    }

    /// Used to generically wrap a UIViewController in a SwiftUI View
    ///
    ///     let view = MyView().asSwiftUIView()
    func asSwiftUIView() -> some View {
        SwiftUIView(view: self)
    }
    
    /// Used to generically wrap a UIViewController in a SwiftUI View for previews
    /// with size layout constraints
    ///
    ///     let view = MyView().asPreview( .zero )
    func asPreview( size: CGSize = .zero ) -> some View {
        if size == .zero {
            return SwiftUIView(view: self)
                .previewLayout( .sizeThatFits )
        }
        else {
            return SwiftUIView(view: self)
                .previewLayout( .fixed( width: size.width, height: size.height ) )
        }
    }
}

