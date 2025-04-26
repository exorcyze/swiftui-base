//
//  EnvironmentObservable.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 4/25/25.
//

import SwiftUI

struct TestModel {
    let name: String
    
    static let mock = TestModel( name: "Foo Bar" )
}

protocol ServiceRepresentable: Observable {
    var model: TestModel { get }
}

/*
@Observable
class DataService: ServiceRepresentable {
    private(set) var model: TestModel
    func fetchData() {}
}
*/

@Observable
class DataServiceMock: ServiceRepresentable {
    let model: TestModel = .mock
}

extension EnvironmentValues {
    @Entry var dataService: any ServiceRepresentable = DataServiceMock()
}

// now can inject and use either service
// .environment( \.dataService, DataService() )
// @Environment( \.dataService ) private var service
