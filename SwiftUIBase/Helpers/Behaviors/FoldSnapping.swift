//
//  Created by Mike Johnson on 2025.
//

import SwiftUI

/// Implements an above- or below-the-fold snapping behavior for tvOS.
///
/// This behavior uses the expected height of the header to determine the
/// snapping behavior, depending on whether the view is currently above the fold
/// (showing the header) or below (showing only the shelves).  When a scroll
/// event moves the scroll view's content bounds beyond a certain threshold, it
/// changes the target of the scroll so that it either snaps to the top of the
/// scroll view, or snaps to a point below the header.
///
/// Applying the behavior to the base scroll view:
///
///     .scrollTargetBehavior( FoldSnapping( isAboveFold: !isBelowFold, foldHeight: foldHeight ) )
///
/// Updating the isBelowFold inside the headerView:
///
///     .onScrollVisibilityChange { visible in
///         withAnimation { isBelowFold = !visible }
///     }

struct FoldSnapping: ScrollTargetBehavior {
    var isAboveFold: Bool
    var foldHeight: CGFloat

    /// This takes a `ScrollTarget` that contains the proposed end point of
    /// the current scroll event.  In tvOS, this is the target of a scroll
    /// that the focus engine triggers when attempting to bring a newly focused
    /// item into view.
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        // If the current scroll offset is near the top of the view and the
        // target is not lower than 30% of the header's height, all is good.
        // This allows a little flexibility when moving toward any buttons that
        // might be part of the header view.
        if isAboveFold && target.rect.minY < foldHeight * 0.3 {
            // The target isn't moving enough to pass the snap point.
            return
        }

        // If the header isn't visible and the target isn't high enough to
        // reveal any of the header, the scroll can land anywhere the system
        // determines within this area.
        if !isAboveFold && target.rect.minY > foldHeight {
            // The target isn't far enough up to reveal the showcase.
            return
        }

        // The view needs to snap upward to reveal the header only if the
        // target is more than 30% of the way up from the bottom edge of the
        // showcase.
        let showcaseRevealThreshold = foldHeight * 0.7

        // If the target of the scroll is anywhere between the header's bottom
        // edge and that threshold, the view needs to snap to hide the header.
        let snapToHideRange = showcaseRevealThreshold...foldHeight

        if isAboveFold || snapToHideRange.contains(target.rect.origin.y) {
            // The view is either above the fold and scrolling more than 30% of
            // the way down, or it's below the fold and isn't moving up far
            // enough to reveal the showcase.

            // This case likely triggers every time you move focus among the
            // items on the top content shelf, as the focus system brings them a
            // little farther onto the screen.  It's very likely that this code
            // is setting the target origin to it's current position here,
            // effectively denying any scrolling at all.
            target.rect.origin.y = foldHeight
        }
        else {
            // The view is below the fold and it's moving up beyond the bottom
            // 30% of the header view.  Snap to the view's origin to reveal the
            // entire header.
            target.rect.origin.y = 0
        }
    }
}

// MARK: - Sample Views

fileprivate struct FoldSnappingSample: View {
    @State private var isBelowFold = false
    private var heroHeight: CGFloat = 800
    
    var body: some View {
        ScrollView( .vertical ) {
            
            VStack( alignment: .leading, spacing: 24 ) {
                heroView
                
                rowView
                rowView
                rowView
            }
            // Use the stack's content views to determine scroll targeting.
            .scrollTargetLayout()
            
        }
        .background( alignment: .top ) { FoldSnappingHeroBackgroundSample( isBelowFold: isBelowFold ) }
        .scrollTargetBehavior(
            FoldSnapping( isAboveFold: !isBelowFold, foldHeight: heroHeight )
        )
        .scrollClipDisabled() // prevent scroll view from clipping raised focus effects
        .frame( maxHeight: .infinity, alignment: .top )
        .ignoresSafeArea( .all )
    }
    
    /// The content inside the hero view, excludes the content for this sample so it
    /// can have dynamic masking, keeping it as the page background
    var heroView: some View {
        VStack( alignment: .leading ) {

            Spacer()

            Text( "Sample Header" )
                .font( .largeTitle ).bold()
            
            Button { } label: {
                Text( "Play Sample" )
            }
        }
        .frame( maxWidth: .infinity, alignment: .leading )
        #if os(tvOS)
        .focusSection()
        #endif
        // Use 80% of the container's vertical space.
        .containerRelativeFrame(.vertical, alignment: .topLeading) { length, _ in length * 0.8 }
        // toggle the fold state if we're more than 50% off-screen
        .onScrollVisibilityChange { visible in
            withAnimation { isBelowFold = !visible }
        }
    }

    var rowView: some View {
        Button { } label: {
            Text( "Sample Button")
        }
        .frame( height: 240 )
        .background( Color.random() )
    }
}

/// Sample hero that uses dynamic material masking
fileprivate struct FoldSnappingHeroBackgroundSample: View {
    var isBelowFold: Bool
    
    var body: some View {
        Image( "Sample Image" )
            .resizable()
            .aspectRatio( contentMode: .fill )
            .overlay {
                // The view builds the material gradient by filling an area with
                // a material, and then masking that area using a linear gradient.
                Rectangle()
                    .fill( .regularMaterial )
                    .mask { maskView }
            }
            .background( Color.random() )
            .ignoresSafeArea()
    }

    var maskView: some View {
        // The gradient makes direct use of the `belowFold` property to
        // determine the opacity of its stops.  This way, when `belowFold`
        // changes, the gradient can animate the change to its opacity smoothly.
        // If you swap out the gradient with an opaque color, SwiftUI builds a
        // cross-fade between the solid color and the gradient, resulting in a
        // strange fade-out-and-back-in appearance.
        LinearGradient(
            stops: [
                .init( color: .black, location: 0.25 ),
                .init( color: .black.opacity( isBelowFold ? 1 : 0.3 ), location: 0.375 ),
                .init( color: .black.opacity( isBelowFold ? 1 : 0 ), location: 0.5 )
            ],
            startPoint: .bottom, endPoint: .top
        )
    }
}

#Preview {
    FoldSnappingSample()
}
