//
//  WithBackgroundView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/17/25.
//

import SwiftUI

struct WithBackgroundView: ViewModifier {
    enum BackgroundType {
        case color( Color )
        case linearGradient( LinearGradient )
        case meshGradient( MeshGradient )
    }
    
    var background: BackgroundType
    var opacity: Double
    
    func body( content: Content ) -> some View {
        ZStack {
            Group {
                switch background {
                case .color(let color): color
                case .linearGradient(let linearGradient): linearGradient
                case .meshGradient(let meshGradient): meshGradient
                }
            }
            .ignoresSafeArea( .all )
            .opacity( opacity )
            
            content
        }
    }
}

extension View {
    func withBackgroundView( _ background: WithBackgroundView.BackgroundType, opacity: Double = 1.0 ) -> some View {
        modifier( WithBackgroundView( background: background, opacity: opacity ) )
    }
}
