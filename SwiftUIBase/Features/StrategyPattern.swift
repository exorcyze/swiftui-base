//
//  StrategyPattern.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/30/25.
//

import Foundation

fileprivate struct SortableUser {
    let name: String
    let age: Int
}

// MARK: - Strategies

fileprivate protocol UserSortingStrategy {
    func sort( _ users: [SortableUser] ) -> [SortableUser]
}

fileprivate struct NameSortingStrategy: UserSortingStrategy {
    func sort(_ users: [SortableUser]) -> [SortableUser] {
        return users.sorted { $0.name.localizedCaseInsensitiveCompare( $1.name ) == .orderedAscending }
    }
}
fileprivate struct AgeSortingStrategy: UserSortingStrategy {
    func sort(_ users: [SortableUser]) -> [SortableUser] {
        return users.sorted { $0.age < $1.age }
    }
}

// MARK: - Context

fileprivate class UserManagerContext {
    private var sortingStrategy: UserSortingStrategy
    
    init( strategy: UserSortingStrategy ) { self.sortingStrategy = strategy }
    func update( _ strategy: UserSortingStrategy ) { self.sortingStrategy = strategy }
    func sort( _ users: [SortableUser] ) -> [SortableUser] { return sortingStrategy.sort( users ) }
}

// MARK: - Sample

fileprivate let sampleUsers = [
    SortableUser( name: "John", age: 30 ),
    SortableUser( name: "Paul", age: 26 ),
    SortableUser( name: "Mary", age: 28 ),
]
fileprivate func testSorting() {
    let context = UserManagerContext( strategy: NameSortingStrategy() )
    let sorted = context.sort( sampleUsers )
}
