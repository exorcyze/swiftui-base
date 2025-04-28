//
//  KeyframeAnimationView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/28/25.
//

import SwiftUI

struct KeyframeAnimationView: View {
    var body: some View {
        VStack {
            HStack( spacing: 12 ) {
                Circle()
                    .fill( .ultraThinMaterial )
                    .frame( width: 45, height: 45 )
                
                VStack( alignment: .leading, spacing: 6 ) {
                    MarqueeText( text: "Some really long song title goes in here to scroll" )
                    
                    Text( "By **Artist Name**")
                        .font( .caption )
                        .foregroundStyle( .secondary )
                }
            }
            .padding( 15 )
            .background( .background, in: .rect( cornerRadius: 12 ) )
            
        }
        .padding( 15 )
        .frame( maxWidth: .infinity, maxHeight: .infinity )
        .background( .gray.opacity( 0.15 ) )
    }
}

struct MarqueeText: View {
    var text: String
    
    @State private var textSize: CGSize = .zero
    @State private var viewSize: CGSize = .zero
    @State private var isMarqueeEnabled: Bool = false
    
    /// Time to hold between cycles
    var holdTime: CGFloat { return 2 }
    /// Speed of the effect
    var speed: CGFloat { return 6 }
    /// Gap between duplicated one
    var gapSize: CGFloat { return 25 }
    
    var body: some View {
        ScrollView( .horizontal ) {
            Text( text )
                .onGeometryChange( for: CGSize.self ) {
                    $0.size
                } action: { newValue in
                    textSize = newValue
                    isMarqueeEnabled = textSize.width > viewSize.width
                }
                .modifiers { content in
                    if isMarqueeEnabled {
                        content
                            .keyframeAnimator(initialValue: 0.0, repeating: true ) { [textSize, gapSize] content, progress in
                                let offset = textSize.width + gapSize
                                
                                content
                                    .overlay( alignment: .trailing ) {
                                        content
                                            .offset( x: offset )
                                    }
                                    .offset( x: -offset * progress )
                                
                            } keyframes: { _ in
                                LinearKeyframe( 0, duration: holdTime )
                                LinearKeyframe( 1, duration: speed )
                            }
                    }
                    else {
                        content
                    }
                }
        }
        .scrollDisabled( true )
        .scrollIndicators( .hidden )
        .onGeometryChange( for: CGSize.self ) {
            $0.size
        } action: { newValue in
            viewSize = newValue
        }
    }
}

extension View {
    @ViewBuilder
    func modifiers<Content: View>( @ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content( self )
    }
}

#Preview {
    NavigationStack {
        KeyframeAnimationView()
            .navigationTitle( "Keyframe Animation" )
            .navigationBarTitleDisplayMode( .inline )
    }
}
