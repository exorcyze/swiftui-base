//
//  Arcs.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/11/25.
//

import SwiftUI

public struct Arcs: View {
    @Binding private var isAnimating: Bool
    public let count: UInt
    public let width: CGFloat
    public let spacing: CGFloat

    public init(animate: Binding<Bool>, count: UInt = 3, width: CGFloat = 2, spacing: CGFloat = 1) {
        self._isAnimating = animate
        self.count = count
        self.width = width
        self.spacing = spacing
    }

    public var body: some View {
        GeometryReader { geometry in
            ForEach(0..<Int(count)) { index in
                item(forIndex: index, in: geometry.size)
                    .rotationEffect(isAnimating ? .degrees(360) : .degrees(0))
                    .animation(
                        Animation.default
                            .speed(Double.random(in: 0.2...0.5))
                            .repeatCount(isAnimating ? .max : 1, autoreverses: false)
                    )
            }
        }
        .aspectRatio(contentMode: .fit)
    }

    private func item(forIndex index: Int, in geometrySize: CGSize) -> some View {
        Group { () -> Path in
            var p = Path()
            p.addArc(center: CGPoint(x: geometrySize.width/2, y: geometrySize.height/2),
                     radius: geometrySize.width/2 - width/2 - CGFloat(index) * (width + spacing),
                     startAngle: .degrees(0),
                     endAngle: .degrees(Double(Int.random(in: 120...300))),
                     clockwise: true)
            return p.strokedPath(.init(lineWidth: width))
        }
        .frame(width: geometrySize.width, height: geometrySize.height)
    }
}

public protocol iActivityIndicatorStyle: View {
    init(animate: Binding<Bool>)
}

extension Arcs: iActivityIndicatorStyle {
    public init(animate: Binding<Bool>) {
        self.init(animate: animate, count: 3, width: 2, spacing: 1)
    }
}

public struct iActivityIndicator: View {

    @State var animate: Bool = false
    private let style: AStyle

    public var body: some View {
        Group {
            switch style {
            case let .arcs(count, width, spacing):
                Arcs(
                    animate: $animate,
                    count: count,
                    width: width,
                    spacing: spacing
                )
            }
        }
            .onAppear { animate = true }
            .onDisappear { animate = false }
            .aspectRatio(contentMode: .fit)
    }

    public init(style: AStyle = .arcs(count: 3, width: 2, spacing: 1) ) {
        self.style = style
    }
}

public enum AStyle {
    case arcs(count: UInt = 3, width: CGFloat = 2, spacing: CGFloat = 1)
}

#Preview {
    iActivityIndicator(style: .arcs())
        .frame( width: 80, height: 80 )
        .foregroundStyle( .blue )
}
