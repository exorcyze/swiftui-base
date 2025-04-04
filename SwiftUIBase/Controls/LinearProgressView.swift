//
//  LinearProgressView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/18/25.
//

import SwiftUI

// Original : https://stackoverflow.com/a/79056508

struct LinearProgressView<Shape: SwiftUI.Shape>: View {
    var value: Double
    var shape: Shape
    var backgroundColor: Color?
    
    var body: some View {
        filledShape
            .overlay( alignment: .leading ) {
                GeometryReader { proxy in
                    shape.fill( .tint )
                        .frame( width: proxy.size.width * value, alignment: .leading )
                }
            }
            .clipShape( shape )
    }
    var filledShape: some View {
        Group {
            if let backgroundColor { shape.fill( backgroundColor ) }
            else { shape.fill( .foreground.quaternary ) }
        }
    }
}

extension LinearProgressView where Shape == Capsule {
    init( value: Double, shape: Shape = Capsule() ) {
        self.value = value
        self.shape = shape
    }
}

// Options to use for .fill
extension Color {
    func shapeStyle() -> some ShapeStyle { self }
}
struct BackgroundShapeStyle: ShapeStyle {
    // as of iOS 17+
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle { Color.black.opacity( 0.3 ) }
}
struct SystemShapeStyle: ShapeStyle {
    func resolve(in environment: EnvironmentValues) -> some ShapeStyle { .foreground.quaternary }
}

#Preview(traits: .sizeThatFitsLayout) {
    VStack {
        LinearProgressView( value: 0.6 )

        LinearProgressView( value: 0.2, shape: Rectangle(), backgroundColor: .yellow.opacity( 0.5 ) )
            .tint( Gradient( colors: [.red, .orange] ) )
            .clipShape( Capsule() )
        
        LinearProgressView( value: 0.4, shape: Rectangle() )
            .tint( Gradient( colors: [.orange, .red] ) )
        
        LinearProgressView( value: 0.6, shape: Capsule() )
            .tint( Gradient( colors: [.purple, .blue] ) )

        LinearProgressView( value: 0.8, shape: RoundedRectangle( cornerRadius: 4 ) )
            .tint( LinearGradient( colors: [.green, .cyan], startPoint: .leading, endPoint: .trailing ) )
    }
    .frame( height: 100 )
    .padding()
}
