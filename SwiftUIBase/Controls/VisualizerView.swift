//
//  VisualizerView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/27/25.
//

import SwiftUI

struct VisualizerView: View {
    private let barMinHeight: CGFloat = 20
    private let barMaxHeight: CGFloat = 80
    private let barGroups = 20
    private let barsPerGroup = 10
    private let minCoreSize: CGFloat = 180
    private let maxCoreSize: CGFloat = 200
    private let coreAnimationDuration: Double = 0.2
    @State private var coreSize: CGFloat = 50
    
    var body: some View {
        ZStack {
            ZStack {
                ForEach( 0..<barGroups, id: \.self ) { i in
                    BarGroup( barMinHeight: barMinHeight, barMaxHeigbht: barMaxHeight, barOffset: minCoreSize / 2, barWidth: 2, barCount: barsPerGroup )
                        .rotationEffect( .degrees( 360 / Double( barGroups * barsPerGroup ) ) * Double( i ) )
                    
                    Circle()
                        .fill( .background )
                        .frame( width: coreSize )
                        .animation( .easeInOut( duration: coreAnimationDuration ), value: coreSize )
                        .task( id: coreSize ) {
                            try? await Task.sleep( for: .seconds( coreAnimationDuration ) )
                            coreSize = CGFloat.random( in: minCoreSize...maxCoreSize )
                        }
                }
                
                Image( systemName: "music.note" )
                    .resizable()
                    .scaledToFit()
                    .frame( width: 48, height: 48 )
            }
        }
    }
}

struct Line: Shape {
    func path( in rect: CGRect ) -> Path {
        var path = Path()
        path.move( to: CGPoint( x: rect.midX, y: rect.minY ) )
        path.addLine( to: CGPoint( x: rect.midX, y: rect.maxY ) )
        return path
    }
}

struct BarGroup: View {
    let barMinHeight: CGFloat
    let barMaxHeigbht: CGFloat
    let barOffset: CGFloat
    let barWidth: CGFloat
    let barCount: Int
    let barColor: Color?
    
    private let animationDuration = Double.random( in: 0.1...0.2 )
    
    @State private var barHeights: [CGFloat]
    
    init( barMinHeight: CGFloat, barMaxHeigbht: CGFloat, barOffset: CGFloat, barWidth: CGFloat, barCount: Int, barColor: Color? = nil ) {
        self.barMinHeight = barMinHeight
        self.barMaxHeigbht = barMaxHeigbht
        self.barOffset = barOffset
        self.barWidth = barWidth
        self.barCount = barCount
        self.barColor = barColor
        self.barHeights = [CGFloat]( repeating: 0, count: barCount )
    }
    
    var body: some View {
        ZStack {
            ForEach( 0..<barCount, id: \.self ) { i in
                Line()
                    .stroke( barColor ?? .primary, style: .init( lineWidth: barWidth, lineCap: .round, dash: [ 2, barWidth, 2, barWidth, 3, barWidth, 4, barWidth, 1000 ] ) )
                    .frame( width: barWidth, height: barHeights[ i ] )
                    .frame( maxHeight: barMaxHeigbht, alignment: .bottom )
                    .frame( width: 2 * barMaxHeigbht, height: 2 * barMaxHeigbht, alignment: .top )
                    .offset( y: -barOffset )
                    .rotationEffect( .degrees( 360 / Double( barCount ) ) * Double( i ) )
            }
        }
        .animation( .easeInOut( duration: animationDuration ), value: barHeights )
        .task( id: barHeights ) {
            try? await Task.sleep( for: .seconds( animationDuration ) )
            var newHeights = [CGFloat]()
            for _ in 0..<barCount { newHeights.append( CGFloat.random( in: barMinHeight...barMaxHeigbht ) ) }
            barHeights = newHeights
        }
    }
}

#Preview {
    VisualizerView()
}
