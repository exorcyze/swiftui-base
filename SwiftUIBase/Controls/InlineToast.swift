//
//  InlineToast.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/25/25.
//

// https://www.youtube.com/watch?v=pA_8cDvabEY&ab_channel=Kavsoft
import SwiftUI

extension View {
    func inlineToast( config: InlineToastConfig, isPresented: Bool ) -> some View {
        VStack( spacing: 10 ) {
            if config.anchor == .bottom { self.compositingGroup() }
            
            if isPresented {
                InlineToastView( config: config )
                    .transition( .asymmetric(
                        insertion: .push( from: config.anchor.edge ),
                        removal: .push( from: config.anchor.reverseEdge )
                    ) )
            }
            
            if config.anchor == .top { self.compositingGroup() }
        }
        .clipped()
    }
}

struct InlineToastConfig {
    var icon: String
    var title: String
    var subtitle: String
    var tint: Color
    var anchor: InlineToastAnchor = .top
    var animationAnchor: InlineToastAnchor = .top
    var actionIcon: String
    var actionHandler: () -> Void = { }
    
    enum InlineToastAnchor {
        case top, bottom
        
        var edge: Edge { self == .top ? .top : .bottom }
        var reverseEdge: Edge { self != .top ? .top : .bottom }
    }
}

struct InlineToastTestView: View {
    
    @State private var showToast1: Bool = false
    @State private var showToast2: Bool = false
    
    var body: some View {
        let toast1 = InlineToastConfig(icon: "exclamationmark.circle.fill", title: "Incorrect Password", subtitle: "Your password was incorrect. Please try again.", tint: .red, anchor: .top, actionIcon: "xmark" ) { showToast1 = false }
        let toast2 = InlineToastConfig(icon: "checkmark.circle.fill", title: "Password Reset Email Sent", subtitle: "", tint: .green, anchor: .bottom, actionIcon: "xmark" ) { showToast2 = false }
        
        NavigationStack {
            VStack( alignment: .leading, spacing: 15 ) {
                Text( "Email" )
                    .font( .caption )
                    .foregroundStyle( .secondary )
                
                TextField( "", text: .constant( "" ) )
                
                Text( "Password" )
                    .font( .caption )
                    .foregroundStyle( .secondary )
                
                SecureField( "", text: .constant( "" ) )
                
                VStack( alignment: .trailing, spacing: 20 ) {
                    Button {
                        showToast1.toggle()
                    } label:  {
                        Text( "Log In" )
                            .frame( maxWidth: .infinity )
                            .padding( .vertical, 2 )
                    }
                    .tint( .orange )
                    .buttonBorderShape( .roundedRectangle( radius: 10 ) )
                    .buttonStyle( .borderedProminent )

                    Button( "Forgot Password?" ) {
                        showToast2.toggle()
                    }
                }
                .padding( .top, 10 )
                .inlineToast( config: toast2, isPresented: showToast2 )

                Spacer()
            }
            .inlineToast( config: toast1, isPresented: showToast1 )
            .textFieldStyle( .roundedBorder )
            .padding( 15 )
            .navigationTitle( "Login" )
            .animation( .smooth( duration: 0.35, extraBounce: 0 ), value: showToast1 )
            .animation( .smooth( duration: 0.35, extraBounce: 0 ), value: showToast2 )
        }
    }
}

struct InlineToastView: View {
    var config: InlineToastConfig
    
    var body: some View {
        HStack( spacing: 15 ) {
            Image( systemName: config.icon )
                .font( .title2 )
                .foregroundStyle( config.tint )
            
            VStack( alignment: .leading, spacing: 5 ) {
                Text( config.title )
                    .font( .callout )
                    .fontWeight( .semibold )
                
                Text.optional( config.subtitle )?
                    .font( .caption2 )
                    .foregroundStyle( .secondary )
            }
            
            Spacer( minLength: 0 )
            
            Button( action: config.actionHandler ) {
                Image( systemName: config.actionIcon )
                    .foregroundStyle( .secondary )
                    .contentShape( .rect )
            }
        }
        .padding()
        .background {
            ZStack {
                Rectangle()
                    .fill( .background )
                
                HStack( spacing: 0 ) {
                    Rectangle()
                        .fill( config.tint )
                        .frame( width: 5 )
                    
                    Rectangle()
                        .fill( config.tint.opacity( 0.15 ) )
                }
            }
        }
    }
}

#Preview {
    InlineToastTestView()
}
