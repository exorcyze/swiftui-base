//
//  Coordinator.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/3/25.
//

import SwiftUI

/// The type that our enums of pages conform to, allowing them to be used by our Coordinator
typealias Navigable = View & Identifiable & Hashable

/// Used to create a new navigation stack from NavigationStacks enums
///
///     NavStack( MainNavStack.root )
struct NavStack<NavigationPage: Navigable>: View {
    
    let root: NavigationPage
    
    @State private var coordinator = Navigator<NavigationPage>()
    
    init( _ root: NavigationPage ) { self.root = root }
    
    var body: some View {
        NavigationStack( path: $coordinator.path ) {
            root
                .navigationDestination( for: NavigationPage.self ) { $0 }
                .sheet( item: $coordinator.sheet ) { $0 }
                .fullScreenCover( item: $coordinator.fullScreenCover ) { $0 }
        }
        .environment( coordinator )
    }
}

/// The main Navigator is used for the logic in pushing, popping, and presenting views.
@Observable
class Navigator<NavigationPage: Navigable> {
    
    var path: NavigationPath = NavigationPath()
    var sheet: NavigationPage?
    var fullScreenCover: NavigationPage?
    
    enum PushType {
        case link, sheet, fullScreenCover
    }
    enum PopType {
        case link( last: Int )
        case sheet
        case fullScreenCover
    }
    
    func push( _ page: NavigationPage, type: PushType = .link ) {
        switch type {
        case .link: path.append( page )
        case .sheet: sheet = page
        case .fullScreenCover: fullScreenCover = page
        }
    }
    
    func pop( _ type: PopType = .link( last: 1 ) ) {
        switch type {
        case .link(last: let last): path.removeLast( last )
        case .sheet: sheet = nil
        case .fullScreenCover: fullScreenCover = nil
        }
    }
    
    func popToRoot() {
        path.removeLast( path.count )
    }
}
