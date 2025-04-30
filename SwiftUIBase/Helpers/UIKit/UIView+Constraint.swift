//
// Created : Mike Johnson, 2021
//

import Foundation
import UIKit

protocol Constrainable {}
extension UIView : Constrainable {}
extension Int : Constrainable {}
extension UIView {
    /// Constrains a view to it's super view width with margins.
    ///
    ///     view.constrainWidth( left: 20, right: 20 )
    @discardableResult
    func constrainWidth( left: CGFloat = 0, right: CGFloat = 0 ) -> UIView {
        guard let superview = self.superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor, constant: left ).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor, constant: right * -1 ).isActive = true
        return self
    }
    /// Constrains a view to it's super view height with margins.
    ///
    ///     view.constrainHeight( top: 20, bottom: 100 )
    @discardableResult
    func constrainHeight( top: CGFloat = 0, bottom: CGFloat = 0 ) -> UIView {
        guard let superview = self.superview else { return self }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: top ).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: bottom * -1 ).isActive = true
        return self
    }
    
    /// Simpler syntax for setting up constraint dependencies.
    /// Inspired by https://gist.github.com/jtbandes/6959f4f0b80e4cf7d0a0
    ///
    ///     label.constrain( .top, to: image, .bottom, plus: 20 )
    @discardableResult
    func constrain( _ attribute: NSLayoutConstraint.Attribute, _ relation: NSLayoutConstraint.Relation = .equal, to otherView: Any?, _ otherAttribute: NSLayoutConstraint.Attribute, times multiplier: CGFloat = 1, plus constant: CGFloat = 0, atPriority priority: UILayoutPriority = .defaultHigh ) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: relation, toItem: otherView, attribute: otherAttribute, multiplier: multiplier, constant: constant )
        c.priority = priority
        c.isActive = true
        return self
    }
    /// Used to constrain a single property to a single value
    ///
    ///     button.constrain( .height, to: 40 ).constrain( .width, to: 100 )
    @discardableResult
    func constrain( _ attribute: NSLayoutConstraint.Attribute, to constant: CGFloat = 0 ) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let c = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: attribute, multiplier: 1, constant: constant)
        c.isActive = true
        return self
    }
    /// Takes combo of Int and View parameters to stack vertically in the container
    /// ( self ). Int values represent the padding between two subsequent views.
    /// An initial parameter of an Int will be the spacing to the top of the container
    /// view ( self ).
    ///
    ///     container.constrainVStack( 10, UIView(), 20, UIButton(), 10, UIView() )
    func constrainVStack( _ viewsAndSpacing: Constrainable... ) {
        // start with the containing view
        var lastView = self
        var lastPad: CGFloat = 0
        for item in viewsAndSpacing {
            // update position
            if let m = item as? Int { lastPad = CGFloat( integerLiteral: m ) }
            // place view with previous padding
            if let v = item as? UIView {
                let lastAttribute: NSLayoutConstraint.Attribute = ( lastView === self ) ? .top : .bottom
                v.constrain( .top, to: lastView, lastAttribute, plus: lastPad )
                lastView = v
            }
        }
    }
}
