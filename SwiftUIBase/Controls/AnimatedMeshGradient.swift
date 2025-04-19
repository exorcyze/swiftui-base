//
//  AnimatedMeshGradient.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/17/25.
//

// https://www.youtube.com/watch?v=_lsnGyF2WZg&ab_channel=DesignCode

import SwiftUI

struct AnimatedMeshGradient: View {
    
    @State var appear = false
    @State var appear2 = false
    
    var body: some View {
        gradient2
        .onAppear {
            withAnimation( .easeInOut( duration: 1 ).repeatForever( autoreverses: true ) ) {
                appear.toggle()
            }
            withAnimation( .easeInOut( duration: 3 ).repeatForever( autoreverses: true ) ) {
                appear2.toggle()
            }
        }
    }
    
    var gradient1: some View {
        MeshGradient( width: 3, height: 3, points: [
            [ 0, 0 ], [ 0.5, 0 ], [ 1, 0 ],
            [ 0, 0.5 ], appear ? [ 0.5, 0.5 ] : [0.8, 0.2], [ 1, 0.5 ],
            [ 0, 1 ], [ 0.5, 1 ], [ 1, 1 ],
        ], colors: [
            .blue, .purple, .indigo,
            .orange, .white, .blue,
            .yellow, .green, .mint
        ] )
    }
    var gradient2: some View {
        MeshGradient( width: 3, height: 3, points: [
            [ 0, 0 ], [ appear2 ? 0.5 : 1.0, 0 ], [ 1, 0 ],
            [ 0, 0.5 ], appear ? [ 0.5, 0.5 ] : [0.8, 0.2], [ 1, -0.5 ],
            [ 0, 1 ], [ 1, appear2 ? 2 : 1 ], [ 1, 1 ],
        ], colors: [
            appear2 ? .red : .mint, appear2 ? .yellow : .cyan, .orange,
            appear ? .blue : .red, appear ? .cyan : .white, appear ? .red : .purple,
            appear ? .red : .cyan, appear ? .mint : .blue, appear2 ? .red : .blue
        ] )
    }
}

struct AnimatedMeshGradientTestView: View {
    var body: some View {
        HStack {
            Label( "Generate", systemImage: "sparkles" )
                .foregroundStyle( .white )
                .padding()
                .frame( maxWidth: .infinity )
                .background {
                    AnimatedMeshGradient()
                        .mask(
                            RoundedRectangle( cornerRadius: 16 )
                                .stroke( lineWidth: 16 )
                                .blur( radius: 4 )
                        )
                        .overlay(
                            RoundedRectangle( cornerRadius: 16 )
                                .stroke( .white, lineWidth: 3 )
                                .blur( radius: 2 )
                                .blendMode( .overlay )
                        )
                        .overlay(
                            RoundedRectangle( cornerRadius: 16 )
                                .stroke( .white, lineWidth: 1 )
                                .blur( radius: 1 )
                                .blendMode( .overlay )
                        )
                }
                .background( .black )
                .cornerRadius( 16 )
                .padding()
        }
    }
}
#Preview {
    ZStack {
        AnimatedMeshGradient()
        
        AnimatedMeshGradientTestView()
    }
    .ignoresSafeArea( .all )
}
