//
//  Created by Mike Johnson on 2025.
//

import SwiftUI

struct WithBackgroundView: ViewModifier {
    enum BackgroundType {
        case color( Color )
        case linearGradient( LinearGradient )
        case meshGradient( MeshGradient )
    }
    
    var background: BackgroundType
    var opacity: Double
    
    func body( content: Content ) -> some View {
        ZStack {
            Group {
                switch background {
                case .color(let color): color
                case .linearGradient(let linearGradient): linearGradient
                case .meshGradient(let meshGradient): meshGradient
                }
            }
            .ignoresSafeArea( .all )
            .opacity( opacity )
            
            content
        }
    }
}

extension View {
    /// Allows one of multiple types of background views to be set
    ///
    ///     Text( "Test" ).withBackgroundView( .linearGradient( mygradient ) )
    func withBackgroundView( _ background: WithBackgroundView.BackgroundType, opacity: Double = 1.0 ) -> some View {
        modifier( WithBackgroundView( background: background, opacity: opacity ) )
    }
}
