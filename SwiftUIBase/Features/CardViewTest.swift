//
//  CardViewTest.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/17/25.
//

import SwiftUI

struct CardViewTest: View {
    var body: some View {
        VStack {
            GroupBox( "Content Title" ) {
                RandomText( min: 10, max: 10 )
            }
            
            GroupBox {
                GroupBox { MusicPlayerView() }
                    .groupBoxStyle( .music )
            } label: {
                Label( "Now Playing", systemImage: "music.note" )
            }
            .groupBoxStyle( .music )

        }
        .padding()
        .withBackgroundView( .color( .blue ), opacity: 0.5 )
    }
}

struct MusicPlayerView: View {
    var body: some View {
        VStack {
            HStack {
                RoundedRectangle( cornerRadius: 8 )
                    .frame( width: 50, height: 50 )
                    .foregroundStyle( .secondary )
                
                VStack( alignment: .leading, spacing: 2 ) {
                    Text( "Song Title" )
                        .font( .headline.bold() )
                    
                    Text( "Artist Name" )
                        .font( .footnote )
                        .foregroundStyle( .secondary )
                }
                
                Spacer()
            }
            .padding( .bottom, 8 )
            
            ProgressView( value: 0.4, total: 1 )
                .tint( .secondary )
                .padding( .bottom, 20 )
            
            HStack( spacing: 30 ) {
                Image( systemName: "backward.fill" )
                Image( systemName: "pause.fill" )
                Image( systemName: "forward.fill" )
            }
            .foregroundStyle( .secondary )
            .font( .title )
        }
    }
}

struct MusicGroupBoxStyle: GroupBoxStyle {
    func makeBody( configuration: Configuration ) -> some View {
        VStack( alignment: .leading ) {
            configuration.label
                .bold()
                .foregroundStyle( .pink )
            configuration.content
        }
        .padding()
        .background( .regularMaterial, in: RoundedRectangle( cornerRadius: 12 ) )
    }
}
extension GroupBoxStyle where Self == MusicGroupBoxStyle {
    static var music: MusicGroupBoxStyle { .init() }
}

#Preview {
    CardViewTest()
}
