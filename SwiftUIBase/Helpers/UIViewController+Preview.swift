//
//  UIViewController+Preview.swift
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
@available(iOS 13, *)
struct MyViewControllerPreview: PreviewProvider {
    static var previews: some View {
        MyViewController(data: mydata).asPreview()
    }
}
#endif
*/

// View Usage:
/*
#if canImport(SwiftUI) && DEBUG
import SwiftUI
@available(iOS 13, *)
struct TestView_Preview: PreviewProvider {
    static var previews: some View {
        TestView().asPreview()
    }
}
#endif
*/

// MARK: - UIViewController extensions

extension UIViewController {
    @available(iOS 13, *)
    private struct Preview: UIViewControllerRepresentable {
        var viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            // No-op
        }
    }

    @available(iOS 13, *)
    func asPreview() -> some View {
        Preview(viewController: self)
    }
}

// MARK: - UIView Extensions

extension UIView {
    @available(iOS 13, *)
    private struct Preview: UIViewRepresentable {
        var view: UIView

        func makeUIView(context: Context) -> UIView {
            view
        }

        func updateUIView(_ view: UIView, context: Context) {
            // No-op
        }
    }

    @available(iOS 13, *)
    func asPreview( size: CGSize = .zero ) -> some View {
        if size == .zero {
            return Preview(view: self)
                .previewLayout( .sizeThatFits )
        }
        else {
            return Preview(view: self)
                .previewLayout( .fixed( width: size.width, height: size.height ) )
        }
    }
}

