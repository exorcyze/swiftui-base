//
//  StickyHeaderView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/30/25.
//

// https://www.youtube.com/watch?v=2NMjFuiZ5Po&ab_channel=Kavsoft

// Alternate version : https://www.youtube.com/watch?v=rPFLsCdt77Y&ab_channel=SuCodee

import SwiftUI

struct StickyHomeView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView( .vertical, showsIndicators: false ) {
                VStack( spacing: 0 ) {
                    HeaderView()
                        .zIndex( 1000 )
                    
                    SampleCardView()
                }
                .id( "SCROLLVIEW" )
                .background {
                    ScrollDetector { offset in
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        // this snapping can be removed along with ScrollViewReader and .id if functionality is
                        // not desired
                        let headerHeight = ( size.height * 0.3 ) + safeArea.top
                        let minHeaderHeight = 65 + safeArea.top
                        
                        let targetEnd = offset + ( velocity * 45 )
                        if targetEnd < ( headerHeight - minHeaderHeight ) && targetEnd > 0 {
                            withAnimation( .interactiveSpring( response: 0.55, dampingFraction: 0.65, blendDuration: 0.65 ) ) {
                                scrollProxy.scrollTo( "SCROLLVIEW", anchor: .top )
                            }
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = ( size.height * 0.3 ) + safeArea.top
        let minHeaderHeight = 65 + safeArea.top
        let actualHeight = headerHeight + offsetY < minHeaderHeight ? minHeaderHeight : headerHeight + offsetY
        // convert our offset into progress ( a percentage for scaling through )
        let progress = max( min( -offsetY / ( headerHeight - minHeaderHeight ), 1 ), 0 )
        
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill( .pink.gradient )
                
                VStack( spacing: 15 ) {
                    GeometryReader {
                        let rect = $0.frame( in: .global )
                        // because image is 1 - 0.7 = 0.3
                        let halfScaledHeight = ( rect.height * 0.3 ) * 0.5
                        let midY = rect.midY
                        let bottomPadding: CGFloat = 15
                        let resizedOffsetY = ( midY - ( minHeaderHeight - halfScaledHeight - bottomPadding ) )
                        
                        Image( systemName: "person.circle.fill" )
                            .resizable()
                            .aspectRatio( contentMode: .fill )
                            .foregroundStyle( .white )
                            .frame( width: rect.width, height: rect.height )
                            .clipShape( Circle() )
                            .scaleEffect( 1 - ( progress * 0.7 ), anchor: .leading )
                            .offset( x: -( rect.minX - 15 ) * progress, y: -resizedOffsetY * progress )
                        
                    }
                    .frame( width: headerHeight * 0.5, height: headerHeight * 0.5 )
                    
                    Text( "User Name" )
                        .font( .title2 )
                        .fontWeight( .bold )
                        .foregroundStyle( .white )
                        .scaleEffect( 1 - ( progress * 0.15 ) )
                        .offset( y: -4.5 * progress )
                }
                .padding( .top, safeArea.top )
                .padding( .bottom, 15 )
            }
            .frame( height: actualHeight, alignment: .bottom )
            // Stick to the top
            .offset( y: -offsetY )
        }
        .frame( height: headerHeight )
    }
    
    @ViewBuilder
    func SampleCardView() -> some View {
        VStack( spacing: 15 ) {
            ForEach( 1...25, id: \.self ) { _ in
                RoundedRectangle( cornerRadius: 10, style: .continuous )
                    .fill( .black.opacity( 0.05 ) )
                    .frame( height: 75 )
            }
        }
        .padding( 15 )
    }
}


struct StickyHeaderView: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            StickyHomeView( size: size, safeArea: safeArea )
                .ignoresSafeArea( .all, edges: .top )
        }
    }
}

/// Allows us to monitor offset and velocity of the scroll view
/// by accessing the underlying UIKit ScrollView
struct ScrollDetector: UIViewRepresentable {
    var onScroll: (CGFloat) -> ()
    /// Offset, Velocity
    var onDraggingEnd: (CGFloat, CGFloat) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator( parent: self )
    }
    
    func makeUIView(context: Context) -> some UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isDelegateAdded {
                scrollView.delegate = context.coordinator
                context.coordinator.isDelegateAdded = true
            }
        }
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ScrollDetector
        var isDelegateAdded = false
        
        init( parent: ScrollDetector ) { self.parent = parent }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.onScroll( scrollView.contentOffset.y )
        }
        
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            parent.onDraggingEnd( targetContentOffset.pointee.y, velocity.y )
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let velocity = scrollView.panGestureRecognizer.velocity( in: scrollView.panGestureRecognizer.view )
            parent.onDraggingEnd( scrollView.contentOffset.y, velocity.y )
        }
    }
}

#Preview {
    StickyHeaderView()
}
