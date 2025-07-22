//
//  TypeDriven.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 5/15/25.
//

import SwiftUI

// https://swiftology.io/articles/typestate/#:~:text=Typestate%20brings%20the%20concept%20of,compile%20time%20rather%20than%20runtime.
// https://gist.github.com/Alex-Ozun/9669bb1b02be1f63cb509ea859869c31#file-typestate-tesla-car-swift

// MARK: - Base Implementation

enum State1 {}
enum State2 {}

struct Item<State>: ~Copyable {
    private(set) var total: Int
    private init( total: Int ) { self.total = total }
}

extension Item where State == State1 {
    init() { self.init( total: 0 ) }
    consuming func addToTotal() -> Item<State2> {
        Item<State2>( total: total + 1 )
    }
}

extension Item where State == State2 {
    consuming func removeTotal() -> Item<State1> {
        Item<State1>( total: total - 1 )
    }
}

func orderSample() {
    var state = Item<State1>()
        .addToTotal()
        .removeTotal()
        .addToTotal()
}

// MARK: - Combined Implementation

enum ItemState: ~Copyable {
    case state1( Item<State1> )
    case state2( Item<State2> )
    
    init() { self = .state1( Item<State1>() ) }
    
    mutating func total() -> Int {
        let total: Int
        switch consume self {
        case let .state1( state1 ):
            total = state1.total
            self = .state1( state1 )
        case let .state2( state2 ):
            total = state2.total
            self = .state2( state2 )
        }
        return total
    }
    
    mutating func add() {
        switch consume self {
        case let .state1( state1 ):
            let newState = state1.addToTotal()
            self = .state2( newState )
        case let .state2( state2 ):
            self = .state2( state2 )
        }
    }
    
    mutating func remove() {
        switch consume self {
        case let .state1( state1 ):
            self = .state1( state1 )
        case let .state2( state2 ):
            let newState = state2.removeTotal()
            self = .state1( newState )
        }
    }
}

func combinedSample() {
    var itemState = ItemState()
    itemState.add()
    itemState.remove()
    itemState.add()
    print( itemState.total() )
}
