//
//  CountryDetailsViewModel.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import RxSwift
import RxCocoa

struct CountryDetailsViewModel: LoadableViewModel {
    typealias T = Countries
    
    var name: Driver<String>?
    var capital: Driver<String>?
    var currencies: Driver<String>?
    
    var eventDriver: EventDriver<T>?
    
    init(apiClient: CountriesAPIClient,
         countryName: String,
         refreshDriver: Driver<Void> = Driver.empty()) {
        
        let driver = refreshDriver
            .startWith(())
            .flatMapLatest { (_) -> Driver<LoadingEvent<Countries>> in
                return apiClient.details(for: countryName)
                    .debug("Fetching details for: \(countryName)")
                    .map { .data($0) }
                    .asDriver(onErrorJustReturn: .error)
                    .startWith(.loading)
        }
        
        eventDriver = EventDriver(driver: driver)
        
        let detailsDataDriver = driver
            .map { event -> Country? in
                switch event {
                case .data(let data) where data.first != nil:
                    return data.first
                default: return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
        
        name = detailsDataDriver.map { $0.name }
        capital = detailsDataDriver.map { $0.capital }
        currencies = detailsDataDriver.map {
            $0.currencies.map { "\($0.name) (\($0.symbol))" }
            .joined(separator: ", ")
        }
    }
}
