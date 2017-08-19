//
//  API.Base.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import UIKit

extension API {
    
    /// Static shorthand for app-wide API client
    public static let shared = CountriesAPIClient()
}

/// Extenson for system's URL type is used to provide a shorthands for
/// application specific base url instantiation
extension URL {
    public static let baseURLString = "https://restcountries.eu/rest/v2/"
    public static let base = URL(string: URL.baseURLString)!
}
