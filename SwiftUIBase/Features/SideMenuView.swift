//
//  SideMenuView.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/10/25.
//

// https://www.youtube.com/watch?v=5T6ft6B5ZtA&ab_channel=AppStuff

import SwiftUI

struct SideMenuTestView: View {
    @State private var showMenu = false
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                VStack {
                    Text( "Testing" )
                }
                
                SideMenuView( isShowing: $showMenu )
            }
            .toolbar( showMenu ? .hidden : .visible, for: .navigationBar )
            .navigationTitle( "Home" )
            .navigationBarTitleDisplayMode( .inline )
            .toolbar {
                ToolbarItem( placement: .topBarLeading) {
                    Button {
                        showMenu.toggle()
                    } label: {
                        Image( systemName: "line.3.horizontal")
                    }
                }
            }
            .padding()

        }
    }
}

struct SideMenuView: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity( 0.3 )
                    .ignoresSafeArea( .all )
                    .onTapGesture { isShowing.toggle() }
                
                HStack {
                    VStack( alignment: .leading, spacing: 32 ) {
                        header
                        Spacer()
                    }
                    .padding()
                    .frame( width: 270, alignment: .leading )
                    .background( .white )
                    
                    Spacer()
                }
            }
        }
        .transition( .move(edge: .leading ) )
        .animation( .easeInOut, value: isShowing )
    }
    
    var header: some View {
        HStack {
            Image( systemName: "person.circle.fill" )
                .imageScale( .large )
                .foregroundStyle( .white )
                .frame( width: 48, height: 48 )
                .background( .blue )
                .clipShape( RoundedRectangle( cornerRadius: 10 ) )
                .padding( .vertical )
            
            VStack( alignment: .leading, spacing: 6 ) {
                Text( "John Doe" )
                    .font( .subheadline )
                
                Text( "test@test.com" )
                    .font( .footnote )
                    .tint( .gray )
            }
        }
    }
}

#Preview {
    SideMenuTestView()
    //SideMenuView( isShowing: .constant( true ) )
}
