//
//  PhaseAnimationView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/28/25.
//

import SwiftUI

enum OSInfo: String, CaseIterable {
    case ios = "iOS"
    case appleWatch = "watchOS"
    case ipad = "iPadOS"
    case macbook = "macOS"
    case visionOS = "visionOS"
    
    var symbolImage: String {
        switch self {
        case .ios: "iphone"
        case .appleWatch: "applewatch"
        case .ipad: "ipad"
        case .macbook: "macbook"
        case .visionOS: "vision.pro"
        }
    }
}

struct PhaseAnimationView: View {
    // fixes common issue with nav when using looping animations + repeatForever
    @State private var isAnimationEnabled: Bool = false
    
    var body: some View {
        ZStack {
            if isAnimationEnabled {
                PhaseAnimator( OSInfo.allCases ) { info in
                    
                    VStack( spacing: 20 ) {
                        ZStack {
                            ForEach( OSInfo.allCases, id: \.rawValue ) { osInfo in
                                let isSame = osInfo == info
                                if isSame {
                                    Image( systemName: osInfo.symbolImage )
                                        .font( .system( size: 100, weight: .ultraLight, design: .rounded ) )
                                        .transition( .blurReplace( .upUp ) )
                                }
                            }
                        }
                    }
                    .frame( height: 120 )
                    
                    VStack( spacing: 6 ) {
                        Text( "Available On" )
                            .font( .callout )
                            .foregroundStyle( .secondary )
                        
                        ZStack {
                            ForEach( OSInfo.allCases, id: \.rawValue ) { osInfo in
                                let isSame = osInfo == info
                                if isSame {
                                    Text( osInfo.rawValue )
                                        .font( .largeTitle )
                                        .fontWeight( .semibold )
                                        .fontDesign( .rounded )
                                        .transition( .push( from: .bottom ) )
                                }
                            }
                        }
                        .frame( maxWidth: .infinity )
                        .clipped()
                        
                    }
                } animation: { _ in
                    // delay between slides
                        .interpolatingSpring( .bouncy( duration: 1, extraBounce: 0 ) ).delay( 1.5 )
                }
            }
        }
        .task { isAnimationEnabled = true }
    }
}

#Preview {
    NavigationStack {
        PhaseAnimationView()
            .navigationTitle( "Phase Animator" )
            .navigationBarTitleDisplayMode( .inline )
    }
}
