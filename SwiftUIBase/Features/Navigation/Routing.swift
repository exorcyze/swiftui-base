//
//  Created by Mike Johnson, 2025.
//

import SwiftUI

/// The type that our enums of pages conform to, allowing them to be used by our Routing / Route
typealias Routable = View & Identifiable & Hashable

/// Used to create a new navigation stack from NavigationStacks enums
///
///     Route( MainRoute.root )
struct Route<NavigationPage: Routable>: View {
    
    let root: NavigationPage
    
    @State private var nav = Routing<NavigationPage>()
    
    init( _ root: NavigationPage ) { self.root = root }
    
    var body: some View {
        NavigationStack( path: $nav.path ) {
            root
                .navigationDestination( for: NavigationPage.self ) { $0 }
                .sheet( item: $nav.sheet ) { $0 }
                .fullScreenCover( item: $nav.fullScreenCover ) { $0 }
        }
        .environment( nav )
    }
}

/// The main Routing is used for the logic in pushing, popping, and presenting views.
@Observable
class Routing<RouteDestination: Routable> {
    
    var path: NavigationPath = NavigationPath()
    var sheet: RouteDestination?
    var fullScreenCover: RouteDestination?
    
    enum PushType {
        case link, sheet, fullScreenCover
    }
    enum PopType {
        case link( last: Int )
        case sheet
        case fullScreenCover
    }
    
    func push( _ page: RouteDestination, type: PushType = .link ) {
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
