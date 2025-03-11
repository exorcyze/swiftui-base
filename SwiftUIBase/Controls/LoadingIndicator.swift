//
//  LoadingIndicator.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 2/25.
//

import SwiftUI

// Original Source : https://medium.com/@aayan.talukdar/ios-swift-creating-common-full-screen-loading-screen-using-swift-367af97e9fef

/// View modifier extension for applying loading indicator
///
///     List { ... }.loadingIndicator( viewModel.isLoading )
extension View {
    func loadingIndicator(_ isShowing: Bool) -> some View {
        self.modifier(LoadingIndicator(isShowing: isShowing))
    }
}

/// Displays a loading indicator in a rect floating over the specified view
///
///     List { ... }.modifier( LoadingIndicator( isShowing: viewModel.isLoading ) )
struct LoadingIndicator: ViewModifier {
    var isShowing: Bool

    func body( content: Content ) -> some View {
        ZStack {
            content
                //.disabled( isShowing )
                //.blur( radius: isShowing ? 3 : 0 )
            if isShowing { loadingView }
        }
    }

    private var loadingView: some View {
        ProgressView()
            .progressViewStyle( CircularProgressViewStyle( tint: .white ) )
            .scaleEffect( 3 )
            .background(
                RoundedRectangle( cornerRadius: 16 )
                    .foregroundStyle( .black.opacity( 0.7 ) )
                    .frame( width: 160, height: 160 )
            )
            .ignoresSafeArea()
            .transition( AnyTransition.opacity.animation( .easeInOut( duration: 0.2 ) ) )
    }
    
    private var symbolView: some View {
        // progress.indicator, gear, ellipsis, timelapse, aqi.low, aqi.medium
        Image( systemName: "aqi.medium" )
            .symbolEffect( .variableColor.iterative, options: .repeat( .continuous ), value: isShowing )
            .scaleEffect( 3 )
            .foregroundStyle( .white )
            .frame( width: 80, height: 80 )
            .background(
                RoundedRectangle( cornerRadius: 16 )
                    .foregroundStyle( .black.opacity( 0.7 ) )
                    .frame( width: 160, height: 160 )
            )
            .ignoresSafeArea()
            .transition( AnyTransition.opacity.animation( .easeInOut( duration: 0.2 ) ) )
    }
}

