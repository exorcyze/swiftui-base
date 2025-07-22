//
//  BlurView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 7/1/25.
//

import SwiftUI

// https://stackoverflow.com/posts/73950386/revisions

struct BlurViewTest: View {
    var body: some View {
        ZStack {
            List {
                ForEach( 0..<20 ) { _ in MockCell() }
            }
            .safeAreaInset( edge: .bottom ) {
                blurSample
            }
            BlurView(radius: 2.5)
                .frame( maxWidth: 200, maxHeight: 200 )
                .cornerRadius( 12 )
        }
    }
    var blurSample: some View {
        VisualEffectView( effect: UIBlurEffect( style: .systemUltraThinMaterial ) )
            .opacity(0.95)
            .cornerRadius( 12 )
            .frame( maxWidth: .infinity, maxHeight: 70 )
            .padding()
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}


/// A View in which content reflects all behind it
struct BlurringView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
    
}

/// A transparent View that blurs its background
struct BlurView: View {
    
    let radius: CGFloat
    
    @ViewBuilder
    var body: some View {
        BlurringView().blur(radius: radius)
    }
    
}
#Preview {
    BlurViewTest()
}
