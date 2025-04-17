//
//  StickyHeader18.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/10/25.
//

import SwiftUI

// https://www.youtube.com/watch?v=_H5xLoFJ2jM&ab_channel=donnywals
// iOS 18+

struct StickyHeader18: View {
    @State private var offset: CGFloat = 0
    
    private var baseHeight: CGFloat = 300
    
    var body: some View {
        ZStack( alignment: .top ) {
            Image( systemName: "person.fill" )
                .resizable()
                .aspectRatio( contentMode: .fill )
                .frame( height: baseHeight + max( 0, -offset ) )
                .clipped()
                .transformEffect( .init( translationX: 0, y: -max( 0, offset ) ) )
            
            ScrollView {
                Rectangle()
                    .fill( .clear )
                    .frame( height: baseHeight )
                
                Text( "Offset: \(offset)" )
                
                LazyVStack( alignment: .leading ) {
                    ForEach( 0..<100, id: \.self ) { item in
                        Text( "Item \(item)")
                    }
                }
            }
            .onScrollGeometryChange( for: CGFloat.self, of: { geo in
                return geo.contentOffset.y + geo.contentInsets.top
            }, action: { oldValue, newValue in
                offset = newValue
            } )
        }
    }
}

#Preview {
    StickyHeader18()
}
