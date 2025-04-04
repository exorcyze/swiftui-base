//
//  AnimatedLoadingButton.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/13/25.
//

import SwiftUI

// Original Source : https://www.reddit.com/r/SwiftUI/comments/1jacvav/code_a_dynamic_animated_button_with_swiftui_in/

enum ButtonState { case normal, loading, success }

struct AnimatedLoadingButton: View {
    let title: String
    let action: () -> Void
    @Binding var state: ButtonState
    
    @State private var isAnimating = false
    
    var normalColor: Color = .blue
    var loadingColor: Color = .orange
    var successColor: Color = .green
    
    var width: CGFloat = 200
    var height: CGFloat = 50
    
    var body: some View {
        Button {
            if state == .normal { action() }
        } label: {
            ZStack {
                RoundedRectangle( cornerRadius: state == .loading ? height / 2 : 10 )
                    .frame( width: state == .loading ? height : width, height: height )
                    .foregroundStyle( state == .normal ? normalColor : state == .loading ? loadingColor : successColor )
                
                Group {
                    if state == .normal { normalStateView }
                    if state == .loading { loadingStateView }
                    if state == .success { successStateView }
                }
                .animation( .spring( response: 0.3, dampingFraction: 0.7 ), value: state )
            }
        }
        .disabled( state != .normal )
    }
    
    var normalStateView: some View {
        Text( title )
            .fontWeight( .semibold )
            .foregroundStyle( .white )
            .transition( .opacity )
    }
    
    var loadingStateView: some View {
        Circle()
            .trim( from: 0, to: 0.7 )
            .stroke( .white, lineWidth: 2 )
            .frame( width: height * 0.5, height: height * 0.5 )
            .rotationEffect( Angle( degrees: isAnimating ? 360 : 0 ) )
            .onAppear {
                withAnimation( .linear( duration: 1 ).repeatForever( autoreverses: false ) ) { isAnimating = true }
            }
            .onDisappear { isAnimating = false }
    }
    var successStateView: some View {
        Image( systemName: "checkmark" )
            .font( .system( size: 20, weight: .bold ) )
            .foregroundStyle( .white )
            .transition( .scale.combined( with: .opacity ) )
    }
}

struct AnimatedLoadingButtonPreview: View {
    @State private var buttonState: ButtonState = .normal
    
    var body: some View {
        VStack {
            AnimatedLoadingButton( title: "Submit", action: buttonPressed, state: $buttonState )
        }
    }
    
    func buttonPressed() {
        Task {
            do {
                withAnimation { buttonState = .loading }
                try await Task.sleep( for: .seconds( 2 ) )
                withAnimation { buttonState = .success }
                try await Task.sleep( for: .seconds( 1.5 ) )
                withAnimation { buttonState = .normal }
            } catch { }
        }
    }
}

#Preview {
    AnimatedLoadingButtonPreview()
}
