//
//  SwiftUIBaseTests.swift
//  SwiftUIBaseTests
//
//  Created by Mike Johnson on 3/8/25.
//

import Testing
@testable import SwiftUIBase

struct IsNotEmptyTests {
    
    struct Strings {
        @Test( "IsNotEmpty : String", arguments: [ "" , "FOO" ] )
        func testIsNotEmpty( arg: String ) async throws {
            #expect( arg.isNotEmpty == !arg.isEmpty )
        }

        @Test( "HasCharacters : String", arguments: [ "" , "FOO" ] )
        func testHasCharacters( arg: String ) async throws {
            #expect( arg.hasCharacters == !arg.isEmpty )
        }
    }
    
    @Test func testIsNotEmptyWithEmpty() async throws {
        #expect( "".isNotEmpty == false )
    }
    
}
