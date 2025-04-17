//
//  ListOverlay.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/17/25.
//

import SwiftUI

struct ListOverlayTestView: View {
    var body: some View {
        List {
            ForEach( 0..<20 ) { _ in MockCell() }
        }
        .safeAreaInset( edge: .bottom ) {
            overlaySample
        }
        .navigationTitle( "List Overlay" )
    }
    
    var overlaySample: some View {
        RoundedRectangle( cornerRadius: 12 )
            .foregroundStyle( .pink.gradient.opacity( 0.8 ) )
            .frame( maxWidth: .infinity, maxHeight: 70 )
            .padding()
    }
}

#Preview {
    ListOverlayTestView()
}
