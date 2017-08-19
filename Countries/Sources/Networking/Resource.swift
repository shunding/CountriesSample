//
//  Resource.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import Foundation


/// Used to represent HTTP methods such as GET, POST, PUT, DELETE, etc.
public enum Method: String {
    
    // Currently, only GET method used for all API calls used in the app.
    case get = "GET"
}

/// By implementing this protocol we can provide a set of data required
/// to create a URL request.
public protocol Resource {
    
    /// By implementing this method we are specifing which 
    /// HTTP mehtod should be used by NSURLRequest for API call.
    var method: Method { get }
    
    /// Implement this to specify a path to the endpoint. 
    /// This should be a path relative to the ```baseURL```.
    var path: String { get }
    
    
    /// Here should be a set of data to generate a 
    /// query string for ```URLRequest```.
    var parameters: [String: String]? { get }
    
    /// Used to provide custom http header fields.
    var headers: [String: String]? { get }
}

// MARK: - Defaults
extension Resource {
    var method: Method { return .get }
    var parameters: [String: String]? { return nil }
    var headers: [String: String]? { return nil }
}

extension Resource {
    
    /// Generates request based on current ```Resource``` setup.
    ///
    /// - Parameter baseURL: base URL for API.
    /// - Returns: generated ```URLRequest```
    func request(with baseURL: URL) -> URLRequest {
        
        let url = baseURL.appendingPathComponent(self.path)
        
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components from \(url)")
        }
        
        if let parameters = parameters {
            components.queryItems = parameters.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }
        
        guard let finalUrl = components.url else {
            fatalError("Unable to retrieve final URL")
        }
        
        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            headers.forEach { (key, value) in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
}
