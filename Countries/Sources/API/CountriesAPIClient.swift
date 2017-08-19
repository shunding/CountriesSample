//
//  CountriesAPIClient.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import RxSwift

/// ```CountriesAPIClient``` is the app specific implementaion
/// of ```APIClient```. Provides two calls:
/// - ```func allCountries()```
/// - ```func details(_: String)```
final class CountriesAPIClient: APIClient {
    
    /// Required by ```APIClient``` protocol
    var baseURL: URL {
        return URL.base
    }
    
    /// Calls API to receive all countries list.
    ///
    /// - Returns: observable array of countries.
    func allCountries() -> Observable<[Country]> {
        return objects(resource: API.Countries())
    }
    
    /// Calls API to receive details for country specified by name.
    ///
    /// - Parameter name: country name.
    /// - Returns: observable array of countries.
    func details(for name: String) -> Observable<[Country]> {
        return objects(resource: API.Details(name: name))
    }
}
