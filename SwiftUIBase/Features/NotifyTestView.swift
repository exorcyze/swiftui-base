//
//  NotifyTestView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/25/25.
//

import SwiftUI

enum NotifyAnimationPhase: CaseIterable {
    case initial, lift, shakeLeft, shakeRight
    
    static var sequence: [NotifyAnimationPhase] = [ .initial, .lift, .shakeLeft, .shakeRight, .shakeLeft, .shakeRight ]
    
    var yoffset: CGFloat {
        switch self {
        case .initial: 0
        case .lift, .shakeLeft, .shakeRight: -30
        }
    }
    var scale: CGFloat {
        switch self {
        case .initial: 1
        case .lift, .shakeLeft, .shakeRight: 1.2
        }
    }
    var rotationDegrees: Double {
        switch self {
        case .initial, .lift: 0
        case .shakeLeft: -30
        case .shakeRight: 30
        }
    }
}

struct NotifyTestView: View {
    
    @State private var isNotified = false
    
    var body: some View {
        HStack( spacing: 20 ) {
            Button( "Notify Me" ) { isNotified.toggle() }
                .buttonStyle( .borderedProminent )
                .tint( .pink )
                .fontWeight( .semibold )
                .controlSize( .large )
                .phaseAnimator( [ true, false ]) { content, phase in
                    content
                        .scaleEffect( phase ? 1.1 : 1.0 )
                } animation: { phase in
                    .spring( duration: 1 )
                }
            
            Image( systemName: "bell" )
                .resizable()
                .frame( width: 44, height: 44 )
                .foregroundStyle( .pink )
                .phaseAnimator( NotifyAnimationPhase.sequence, trigger: isNotified) { content, phase in
                    content
                        .scaleEffect( phase.scale )
                        .rotationEffect( .degrees( phase.rotationDegrees ), anchor: .top )
                        .offset( y: phase.yoffset )
                } animation: { phase in
                    switch phase {
                    case .initial, .lift: .spring( bounce: 0.5 )
                    case .shakeLeft, .shakeRight: .easeInOut( duration: 0.15 )
                    }
                }

        }
        .padding()
    }
}

#Preview {
    NotifyTestView()
}
