//
//  JSONDecodable.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: AnyObject]

public protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}

public func decode<T: JSONDecodable>(dictionaries: [JSONDictionary]) -> [T]? {
    return dictionaries.flatMap { T(dictionary: $0) }
}

public func decode<T: JSONDecodable>(dictionary: JSONDictionary) -> T? {
    return T(dictionary: dictionary)
}

public func decode<T: JSONDecodable>(data: Data) -> [T]? {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers]),
        let dictionaries = jsonObject as? [JSONDictionary],
        let objects: [T] = decode(dictionaries: dictionaries) else {
            return nil
    }
    return objects
}

public func decode<T: JSONDecodable>(data: Data) -> T? {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers]),
        let dictionary = jsonObject as? JSONDictionary,
        let object: T = decode(dictionary: dictionary) else {
            return nil
    }
    return object
}
