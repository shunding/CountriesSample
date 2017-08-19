//
//  LoadingEvent.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import Foundation

/// Describes the states of loading process.
///
/// - loading: in progress
/// - data: data received
/// - error: error occured
public enum LoadingEvent<T> {
    case loading
    case data(T)
    case error
}
