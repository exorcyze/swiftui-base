//
//  JSONExtensions.swift
//  SwiftUIBase
//
//  Created by Mike Johnson on 3/8/25.
//

import UIKit

public extension Dictionary where Key == String, Value == String {
    var jsonString : String {
        do {
            let json = try JSONSerialization.data( withJSONObject: self, options: [] )
            return String( data: json, encoding: .ascii ) ?? ""
        }
        catch { print( "Dictionary Encoding Error: \(error.localizedDescription)", level: .error ) }
        return ""
    }
}

public extension Data {
    var jsonDictionary : [String : Any] {
        do{
            guard let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String : Any] else { return [String : Any]() }
            return json
        }
        catch { print( "Data Encoding Error: \(error.localizedDescription)", level: .error ) }
        return [String : Any]()
    }
}

