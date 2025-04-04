//
//  GradientBorder.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/28/25.
//

// https://www.youtube.com/watch?v=PZNGUARnAjU&ab_channel=SuCodee

import SwiftUI

struct GradientBorder: View {
    @State var rotation: CGFloat = 0.0
    
    private var cornerRadius: CGFloat = 16
    private var borderWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            RoundedRectangle( cornerRadius: cornerRadius, style: .continuous )
                .foregroundStyle( Color( hex: 0x404040 ) )
                .frame( width: 200, height: 300 )
            RoundedRectangle( cornerRadius: cornerRadius, style: .continuous )
                .frame( width: 400, height: 160 )
                .foregroundStyle( LinearGradient(colors: [ .blue, .yellow, .orange ], startPoint: .top, endPoint: .bottom ) )
                .rotationEffect( .degrees( rotation ) )
                .mask {
                    RoundedRectangle( cornerRadius: cornerRadius, style: .continuous )
                        .stroke( lineWidth: borderWidth )
                        .frame( width: 200 - borderWidth, height: 300 - borderWidth )
                }
            Text( "Title" )
                .font( .largeTitle )
                .foregroundStyle( .white )
        }
        .onAppear {
            withAnimation( .linear( duration: 4 ).repeatForever( autoreverses: false ) ) {
                rotation = 360
            }
        }
    }
}

#Preview {
    GradientBorder()
        .frame( width: 200, height: 300 )
}
