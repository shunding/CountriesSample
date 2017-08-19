//
//  API.Details.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

extension API {
    /// ```APIClient```-compatible ```Resource``` for
    /// all coutnry details request creation
    struct Details: Resource {
        let name: String
        
        var path: String {
            return "name/\(name)"
        }
        
        let parameters = ["fullText": "true"]
    }
}
