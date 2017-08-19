//
//  LoadableViewModel.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import RxSwift
import RxCocoa

/// Generic protocol used for creating view models
/// for data which should be somehow loaded (e.g. from network).
public protocol LoadableViewModel {
    /// Generic type driven by particular view model
    associatedtype T
    
    /// This driver is used to setup binding for ```isLoading```
    /// and ```hasFailed``` properties.
    var eventDriver: EventDriver<T>? { get set }
    
    var isLoading: Driver<Bool>? { get }
    var hasFailed: Driver<Bool>? { get }
}

extension LoadableViewModel {
    var isLoading: Driver<Bool>? {
        return eventDriver?.isLoading
    }
    
    var hasFailed: Driver<Bool>? {
        return eventDriver?.hasFailed
    }
}
