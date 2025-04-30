//
//  Created : Mike Johnson, 2015
//

import Foundation
import UIKit


public extension UIView {
    
    // MARK: - Positioning Properties
    
    var width : CGFloat {
        get { return self.frame.size.width }
        set { self.frame.size.width = newValue }
    }
    var height : CGFloat {
        get { return self.frame.size.height }
        set { self.frame.size.height = newValue }
    }
    var left : CGFloat {
        get { return self.frame.origin.x }
        set { self.frame.origin.x = newValue }
    }
    var right : CGFloat {
        get { return self.frame.origin.x + self.width }
        set { self.frame.origin.x = newValue - self.width }
    }
    var top : CGFloat {
        get { return self.frame.origin.y }
        set { self.frame.origin.y = newValue }
    }
    var bottom : CGFloat {
        get { return self.frame.origin.y + self.height }
        set { self.frame.origin.y = newValue - self.height }
    }
    var centerX : CGFloat {
        get { return self.left + self.width * 0.5 }
        set { self.left = newValue - self.width * 0.5 }
    }
    var centerY : CGFloat {
        get { return self.top + self.height * 0.5 }
        set { self.top = newValue - self.height * 0.5 }
    }
    var size : CGSize {
        get { return self.frame.size }
        set { self.frame.size = newValue }
    }
    var origin : CGPoint {
        get { return self.frame.origin }
        set { self.frame.origin = newValue }
    }
    var topRight : CGPoint {
        get { return CGPoint( x: self.right, y: self.top ) }
        set { self.right = newValue.x; self.top = newValue.y }
    }
    var bottomRight : CGPoint {
        get { return CGPoint( x: self.right, y: self.bottom ) }
        set { self.right = newValue.x; self.bottom = newValue.y }
    }
    var bottomLeft : CGPoint {
        get { return CGPoint( x: self.left, y: self.bottom ) }
        set { self.left = newValue.x; self.bottom = newValue.y }
    }
    
    // MARK: - Subview Methods
    
    /// Adds multiple subviews at once in the order passed.
    /// - Returns: The originating view
    ///
    ///     myview.addSubviews( titleView, bodyView )
    @discardableResult func addSubviews( _ views: UIView... ) -> UIView {
        views.forEach{ [unowned self] in self.addSubview( $0 ) }
        return self
    }
    /// Removes all subviews from this view
    func removeAllSubviews() {
        self.subviews.forEach{ $0.removeFromSuperview() }
    }
    /// Removes all subviews that match the given class
    ///
    ///     myview.removeSubviewsByClass( UILabel )
    func removeSubviewsByClass<T>( c: T.Type ) {
        self.subviews.filter{ $0 is T }.forEach{ $0.removeFromSuperview() }
    }

    // MARK: - Alignment Methods
    
    /// Pins this view to the right side of it's parent view with
    /// the given padding.
    /// - Returns: The originating view
    @discardableResult func pinRight( rpad: CGFloat ) -> UIView {
        if let sv = self.superview { self.right = sv.width - rpad }
        return self
    }
    
    /// Pins this view to the bottom of it's parent view with
    /// the given padding.
    /// - Returns: The originating view
    @discardableResult func pinBottom( pad: CGFloat ) -> UIView {
        if let sv = self.superview { self.bottom = sv.height - pad }
        return self
    }
    
    /// Pins this view to the width of it's parent view.
    /// - Parameters:
    ///  - lpad: Sets the left edge of the view if passed. Left edge is left unset if not passed.
    ///  - rpad: Used for the padding on the right of this view when pinning the width
    ///
    /// - Returns: The originating view
    @discardableResult func pinWidth( lpad: CGFloat = CGFloat.greatestFiniteMagnitude, rpad: CGFloat ) -> UIView {
        if lpad != CGFloat.greatestFiniteMagnitude { self.left = lpad }
        if let sv = self.superview { self.width = sv.width - self.left - rpad }
        return self
    }
    /// Pins this view to the width of it's parent view and sets the right
    /// padding to match the left edge of the view.
    /// - Returns: The originating view
    @discardableResult func pinWidth() -> UIView { return self.pinWidth( rpad: self.left ) }
    
    /// Pins this view to the height of it's parent view.
    /// - Parameters:
    ///  - tpad: Sets the top edge of the view if passed. Top edge is left unset if not passed.
    ///  - bpad: Used for the padding on the bottom of this view when pinning the height
    ///
    /// - Returns: The originating view
    @discardableResult func pinHeight( tpad: CGFloat = CGFloat.greatestFiniteMagnitude, bpad: CGFloat ) -> UIView {
        if tpad != CGFloat.greatestFiniteMagnitude { self.top = tpad }
        if let sv = self.superview { self.height = sv.height - self.top - bpad }
        return self
    }
    /// Pins this view to the height of it's parent view and sets the bottom
    /// padding to match the top edge of the view.
    /// - Returns: The originating view
    @discardableResult func pinHeight() -> UIView { return self.pinHeight( bpad: self.top ) }

    // MARK: - View Centering
    
    enum CenterDirection {
        case horizontal
        case vertical
    }
    /// Pins the center of this view relative to it's parent view.
    /// - Parameters:
    ///  - directions: List of CenterDirection orientations to center in
    ///
    ///  - Returns: The originating view
    ///
    ///      mybutton.pinCenter(.horizontal, .vertical)
    @discardableResult func pinCenter( _ directions: CenterDirection... ) -> UIView {
        guard let sv = self.superview else { return self }
        for item in directions {
            if item == .horizontal { self.centerX = sv.width * 0.5 }
            if item == .vertical { self.centerY = sv.height * 0.5 }
        }
        return self
    }
    
    // MARK: - Aspect Sizing
    
    /// Sets the height to the given ratio of the current width. Ratio is
    /// passed as division, so 16/9 for a 16:9 aspect ratio
    ///
    /// - Parameters:
    ///   - aspectRatio: Aspect ratio to maintain, as a float
    ///
    /// - Returns: The originating view
    ///
    ///     myimage.pinWidth().pinHeightToWidth( by: 16/9 )
    @discardableResult func pinHeightToWidth( by aspectRatio: CGFloat ) -> UIView {
        self.height = self.width.heightForWidth( by: aspectRatio )
        return self
    }
    /// Sets the width to the given ratio of the current height. Ratio is
    /// passed as division, so 16/9 for a 16:9 aspect ratio
    ///
    /// - Parameters:
    ///   - aspectRatio: Aspect ratio to maintain, as a float
    ///
    /// - Returns: The originating view
    ///
    ///     myimage.pinWidth().pinWidthToHeight( by: 16/9 )
    @discardableResult func pinWidthToHeight( by aspectRatio: CGFloat ) -> UIView {
        self.width = self.height.widthForHeight( by: aspectRatio )
        return self
    }
    /// Sets the height to contain all the subviews
    func sizeHeightForContent( visibleOnly: Bool = true ) {
        let subs = visibleOnly ? subviews.filter { $0.isHidden == false } : subviews
        let nums = subs.map { $0.bottom }
        self.height = nums.max() ?? self.height
    }
}

public extension CGFloat {
    /// Returns the height value to the given ratio of the current value as width.
    /// Ratio is passed as division, so 16/9 for a 16:9 aspect ratio
    ///
    /// - Parameters:
    ///   - aspectRatio: Aspect ratio to maintain, as a float
    ///
    /// - Returns: The height value
    ///
    ///     let myheight = myview.width.heightForWidth( by: 16/9 )
    func heightForWidth( by aspectRatio: CGFloat ) -> CGFloat {
        return self / aspectRatio
    }
    /// Returns the width value to the given ratio of the current value as height.
    /// Ratio is passed as division, so 16/9 for a 16:9 aspect ratio
    ///
    /// - Parameters:
    ///   - aspectRatio: Aspect ratio to maintain, as a float
    ///
    /// - Returns: The width value
    ///
    ///     let width = myview.height.widthForHeight( by: 16/9 )
    func widthForHeight( by aspectRatio: CGFloat ) -> CGFloat {
        return self * aspectRatio
    }
}

// MARK: - Stacking Methods

public protocol Stackable {}
extension UIView : Stackable {}
extension Int : Stackable {}
/// Takes combo of Int and View parameters to stack vertically. Int values
/// will increment the current y-position. Views will increment the current
/// position to the bottom of that view after positioning.
///
/// - Returns: Bottom position of last element
///
///     vstack( 10, UIView(), 20, UIButton(), 10, UIView(), UIView() )
@discardableResult public func vstack( _ viewsAndSpacing: Stackable... ) -> CGFloat {
    var pos: CGFloat = 0
    var skipNext = false
    for item in viewsAndSpacing {
        // place view and update position
        if let v = item as? UIView {
            v.top = pos
            // don't update position if this view was hidden
            // and indicate to skip the next spacing
            skipNext = v.isHidden
            if !v.isHidden {
                pos = v.bottom
            }
        }
        // update position ( if the previous view wasn't hidden )
        if let m = item as? Int {
            if !skipNext { pos += CGFloat( integerLiteral: m ) }
        }
    }
    return pos
}
/// Takes combo of Int and View parameters to stack vertically from the bottom
/// of the parent view upwards. Int values will decrement the current y-position.
/// Views will decrement the current position to the top of that view after positioning.
/// Hidden views will be ignored / skipped.
///
/// - Returns: Top position of last element
///
///     vstackUp( 10, UIView(), 20, UIButton(), 10, UIView(), UIView() )
@discardableResult public func vstackUp( parent: UIView, _ viewsAndSpacing: Stackable... ) -> CGFloat {
    var pos: CGFloat = parent.height
    var skipNext = false
    for item in viewsAndSpacing {
        // place view and update position
        if let v = item as? UIView {
            v.bottom = pos
            // don't update position if this view was hidden
            // and indicate to skip the next spacing
            skipNext = v.isHidden
            if !v.isHidden {
                pos = v.top
            }
        }
        // update position ( if the previous view wasn't hidden )
        if let m = item as? Int {
            if !skipNext { pos -= CGFloat( integerLiteral: m ) }
        }
    }
    return pos
}
/// Takes combo of Int and View parameters to stack horizontally from the right.
/// Int values will decrement the current x-position. Views will decrement the current
/// position to the left of that view after positioning.
/// Hidden views will be ignored / skipped.
///
/// - Returns: Left side position of last element
///
///     hstackBack( 10, UIView(), 20, UIButton(), 10, UIView(), UIView() )
@discardableResult public func hstackBack( parent: UIView, _ viewsAndSpacing: Stackable... ) -> CGFloat {
    var pos: CGFloat = parent.width
    var skipNext = false
    for item in viewsAndSpacing {
        // place view and update position
        if let v = item as? UIView {
            v.right = pos
            // don't update position if this view was hidden
            // and indicate to skip the next spacing
            skipNext = v.isHidden
            if !v.isHidden {
                pos = v.left
            }
        }
        // update position ( if the previous view wasn't hidden )
        if let m = item as? Int {
            if !skipNext { pos -= CGFloat( integerLiteral: m ) }
        }
    }
    return pos
}
/// Takes combo of Int and View parameters to stack horizontally. Int values
/// will increment the current x-position. Views will increment the current
/// position to the right of that view after positioning.
///
/// - Returns: Right side position of last element
///
///     hstack( 10, UIView(), 20, UIButton(), 10, UIView(), UIView() )
@discardableResult public func hstack( _ viewsAndSpacing: Stackable... ) -> CGFloat {
    var pos: CGFloat = 0
    var skipNext = false
    for item in viewsAndSpacing {
        // place view and update position
        if let v = item as? UIView {
            v.left = pos
            // don't update position if this view was hidden
            // and indicate to skip the next spacing
            skipNext = v.isHidden
            if !v.isHidden {
                pos = v.right
            }
        }
        // update position ( if the previous view wasn't hidden )
        if let m = item as? Int {
            if !skipNext { pos += CGFloat( integerLiteral: m ) }
        }
    }
    return pos
}
@discardableResult public func stackHorizontal( _ views: [UIView], withSpacing: CGFloat = 0, andLeft: CGFloat = CGFloat.leastNormalMagnitude ) -> CGFloat {
    var lastRight = CGFloat.leastNormalMagnitude
    for v in views {
        if lastRight == CGFloat.leastNormalMagnitude {
            if andLeft != CGFloat.leastNormalMagnitude { v.left = andLeft }
            lastRight = v.right
            continue
        }
        v.left = lastRight + withSpacing
        lastRight = v.right
    }
    return lastRight
}


public extension UIScrollView {
    /// Sets the content size to contain all the subviews for horizontal scrolling
    func sizeForHorizontalScrolling() {
        let nums = self.subviews.map { $0.right }
        self.contentSize = CGSize( width: nums.max() ?? self.width, height: self.height )
    }
    /// Sets the content size to contain all the subviews for vertical scrolling
    func sizeForVerticalScrolling() {
        let nums = self.subviews.map { $0.bottom }
        self.contentSize = CGSize( width: self.width, height: nums.max() ?? self.height )
    }
}

public extension UILabel {
    /// Sets the height of the label to contain the text given the currently set width.
    ///
    /// - Returns: The originating view
    ///
    @discardableResult func setHeightForContent() -> UILabel {
        let labelHeight = self.sizeThatFits(CGSize(width: self.width, height: CGFloat.greatestFiniteMagnitude)).height
        self.height = labelHeight
        return self
        
        // new way?
        //self.frame.size = self.systemLayoutSizeFitting( CGSize( width: self.width, height: 0 ), withHorizontalFittingPriority: .defaultHigh, verticalFittingPriority: .defaultLow )
        //return self
    }
}

public extension UIButton {
    func setInsets( forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat ) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left,
            bottom: contentPadding.bottom,
            right: contentPadding.right + imageTitlePadding
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: imageTitlePadding,
            bottom: 0,
            right: -imageTitlePadding
        )
    }
}
