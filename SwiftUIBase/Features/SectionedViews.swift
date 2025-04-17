//
//  SectionedViews.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/7/25.
//

import SwiftUI

// https://www.reddit.com/r/SwiftUI/comments/1iiyqxw/top_3_patterns_to_show_sections_of_items_with/

struct SectionedViews: View {
    var body: some View {
        Form {
            TrayView( sectionTitle: "Test Section" )
        }
        
        List {
            ListView( sectionTitle: "Section Title" )
        }
        .listStyle( .insetGrouped )

        List {
            //collapsableSection( title: "Section Title" )
        }
        .listStyle( .insetGrouped )
    }
}

struct TrayView: View {
    let sectionTitle: String
    
    var body: some View {
        Section( sectionTitle ) {
            ScrollView( .horizontal, showsIndicators: false ) {
                HStack { /* image, name, etc ... */ }
            }
        }
    }
}

struct ListView: View {
    let sectionTitle: String
    
    var body: some View {
        Section( sectionTitle ) {
            
        }
        
    }
    
    var item: some View {
        HStack { /* image, name, etc ... */ }
            .padding( 5 )
    }
}

/*
struct collapsableSection: View {
    let title: String
    
    @Binding var expanded: Bool
    var body: some View {
        DisclosureGroup( isExpanded: Binding(
            get: { expandedSection[ sectionKey ] ?? false },
            set: { expandedSection[ sectionKey ] = $0 }
        ) {
            // foreach( items ) { item in }
        } label {
            Text( title ).font( .headline )
        }
    }
}
*/

#Preview {
    SectionedViews()
}
