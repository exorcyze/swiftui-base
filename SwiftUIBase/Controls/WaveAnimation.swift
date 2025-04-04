//
//  WaveAnimation.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/24/25.
//

import SwiftUI

// Source: https://www.youtube.com/watch?v=ZpUPSvQHoAk&ab_channel=JimBeanLit
struct WaveAnimation: View {
    
    @State private var percent = 20.0
    @State private var waveOffset = Angle( degrees: 0 )
    
    var body: some View {
        ZStack {
            Wave(offset: Angle( degrees: waveOffset.degrees ), percent: percent )
                .fill( .blue )
                .ignoresSafeArea( .all )
            
            Text( "\(Int(percent))%" )
                .font( .largeTitle )
        }
        .onAppear {
            withAnimation( .linear( duration: 1.5 ).repeatForever( autoreverses: false ) ) {
                self.waveOffset = Angle( degrees: 360 )
            }
        }
    }
}

struct Wave: Shape {
    var offset: Angle
    var percent: Double
    
    var animatableData: Double {
        get { offset.degrees }
        set { offset = Angle( degrees: newValue ) }
    }
    
    func path( in rect: CGRect ) -> Path {
        var p = Path()
        
        let lowestWave = 0.02
        let highestWave = 1.0
        
        let newPercent = lowestWave + ( highestWave - lowestWave ) * ( percent / 100 )
        let waveHeight = 0.015 * rect.height
        let yoffset = CGFloat( 1 - newPercent ) * ( rect.height - 4 * waveHeight ) + 2 * waveHeight
        let startAngle = offset
        let endAngle = offset + Angle( degrees: 360 + 10 )
        
        p.move( to: CGPoint( x: 0, y: yoffset + waveHeight * CGFloat( sin( offset.radians ) ) ) )
        
        for angle in stride( from: startAngle.degrees, through: endAngle.degrees, by: 5 ) {
            let x = CGFloat( ( angle - startAngle.degrees ) / 360 ) * rect.width
            p.addLine(to: CGPoint( x: x, y: yoffset + waveHeight * CGFloat( sin( Angle( degrees: angle ).radians ) ) ) )
        }
        p.addLine(to: CGPoint( x: rect.width, y: rect.height ) )
        p.addLine(to: CGPoint( x: 0, y: rect.height ) )
        p.closeSubpath()
        
        return p
    }
    var body: some View {
        Text( "HI" )
    }
}

#Preview {
    WaveAnimation()
}
