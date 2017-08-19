//
//  Country.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import Foundation

/// Shorthand type for array of ```Country```s
public typealias Countries = [Country]

/// Presents ```Currency``` object received from the API.
/// Conforms to ```JSONDecodable``` protocol.
public struct Currency: JSONDecodable {
    var code: String
    var name: String
    var symbol: String
    
    public init?(dictionary: JSONDictionary) {
        guard let code = dictionary[JSONKey.code] as? String,
            let name = dictionary[JSONKey.name] as? String,
            let symbol = dictionary[JSONKey.symbol] as? String else { return nil }
        
        self.code = code
        self.name = name
        self.symbol = symbol
    }
    
    enum JSONKey {
        static let code = "code"
        static let name = "name"
        static let symbol = "symbol"
    }
}

/// Presents ```Country``` object received from the API.
/// Conforms to ```JSONDecodable``` protocol.
public struct Country: JSONDecodable {
    
    var name: String
    var capital: String
    var population: Int
    var currencies: [Currency]
    
    public init?(dictionary: JSONDictionary) {
        guard let name = dictionary[JSONKeys.name] as? String,
            let capital = dictionary[JSONKeys.capital] as? String,
            let population = dictionary[JSONKeys.population] as? Int,
            let currencies = dictionary[JSONKeys.currencies] as? [JSONDictionary] else {
                return nil
        }
        
        self.name = name
        self.capital = capital
        self.population = population
        self.currencies = currencies.flatMap { Currency(dictionary: $0) }
    }
    
    enum JSONKeys {
        static let name = "name"
        static let capital = "capital"
        static let population = "population"
        static let currencies = "currencies"
    }
}
