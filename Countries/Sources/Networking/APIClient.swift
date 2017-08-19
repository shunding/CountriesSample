//
//  APIClient.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/// API Namespace
enum API {}

enum APIClientError: Error {
    case authorizationFailed
    case couldNotDecodeJSON
    case badStatus(status: Int)
    case notFound
    case badRequest
    case badResponse
    case noData
    case other(Error)
    case networkUnreachable
}


/// ApiClient is the base protocol to implement API calls. You need to make
/// custom implementation for each remote API you want to interact with.
public protocol APIClient {
    var baseURL: URL { get }
    var session: URLSession { get }
    var cachingEnabled: Bool { get }
    
    func objects<T: JSONDecodable>(resource: Resource) -> Observable<[T]>
    func data(from resource: Resource) -> Observable<Data>
}

extension APIClient {
    
    /// Caching is disabled by default
    var cachingEnabled: Bool {
        return false
    }
    
    /// Default ```session``` implementation
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        if !cachingEnabled {
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.urlCache = nil
        }
        return URLSession(configuration: configuration)
    }
    
    /// Used to request and map objects described with ```Resource```.
    /// Returns observable array of specified ```JSONDecodable``` objects.
    ///
    /// - Parameter resource: API resource.
    /// - Returns: observable array of items decoded from JSON.
    public func objects<T: JSONDecodable>(resource: Resource) -> Observable<[T]> {
        return data(from: resource)
            .retry(3)
            .map { data in
                guard let objects: [T] = decode(data: data) else {
                    throw APIClientError.couldNotDecodeJSON
                }
                return objects
        }
    }
    
    /// This method incapsulates ```URLSessionDataTask``` logic for making
    /// calls to API endpoints. It packs data task into observable sequence 
    /// which manipulates ```Data```s received from the APIs and then all 
    /// the subscribers (Observers) can react for fresh data.
    ///
    /// - Parameter resource: implementation of ```Resource``` protocol
    ///   corresponding to needed API endpoint.
    ///
    /// - Returns: observable sequence with ```Data``` objects received
    ///   from the specified endpoint.
    func data(from resource: Resource) -> Observable<Data> {
        
        // Lets ask ```resource``` to get appropriate ```URLRequest``` object
        let request = resource.request(with: baseURL)
        
        // Then we need to create and return an Observable sequence
        return Observable.create { observer in
            
            // We are starting by creating an ``` URLSessionDataTask``` object
            let task = self.session.dataTask(with: request) { (data, response, error) in
                
                // In closure we need to handle results properly
                // We need to notify our observers about several events:
                if let error = error {
                    print("Data Task Error: \(error)")
                    
                    // In case of error
                    observer.onError(APIClientError.other(error))
                } else {
                    
                    guard let response = response as? HTTPURLResponse else {
                        observer.onError(APIClientError.badResponse)
                        return
                    }
                    
                    guard let data = data else {
                        observer.onError(APIClientError.noData)
                        return
                    }
                    
                    if 200 ..< 300 ~= response.statusCode {
                        
                        // In case of success -- pass data to observers
                        observer.onNext(data)
                        
                        // And notify that current call completed
                        observer.onCompleted()
                    } else {
                        print("Error! Bad Status: \(response.statusCode) for request: \(request)")
                        
                        // In case of bad request status -- notify about error as well
                        observer.onError(APIClientError.badStatus(status: response.statusCode))
                    }
                }
            }
            
            // Just start created task
            task.resume()
            
            // When our observable sequence disposed
            // we need to cancel our task to minimize memory usage
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
