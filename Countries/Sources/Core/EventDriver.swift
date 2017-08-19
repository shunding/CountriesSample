//
//  EventDriver.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import RxSwift
import RxCocoa

/// Incapsulates logic for driving items dependent on loading event states.
public struct EventDriver<T> {
    public let driver: Driver<LoadingEvent<T>>
    public var isLoading: Driver<Bool>
    public var hasFailed: Driver<Bool>
    
    init(driver: Driver<LoadingEvent<T>>) {
        self.driver = driver
        isLoading = self.driver.map { event in
            switch event {
            case .loading: return true
            default: return false
            }
        }
        hasFailed = self.driver.map { event in
            switch event {
            case .error: return true
            default: return false
            }
        }
    }
}
