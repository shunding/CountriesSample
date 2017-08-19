//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import RxSwift
import RxCocoa

struct CountryCellModel {
    let name: String
    let population: String
    
    init(with country: Country) {
        self.name = country.name
        self.population = "Population: \(country.population)"
    }
}

struct CountriesListViewModel: LoadableViewModel {
    typealias T = Countries

    var countriesList: Driver<[CountryCellModel]>?
    
    let cellDidSelect: PublishSubject<Int> = PublishSubject<Int>()
    var presentDetails: Observable<String>?
    
    var eventDriver: EventDriver<T>?
    
    init(apiClient: CountriesAPIClient,
         refreshDriver: Driver<Void>) {
        
        let driver = refreshDriver
            .debug("Refresh Driver")
            .startWith(())
            .flatMapLatest { (_) -> Driver<LoadingEvent<Countries>> in
                return apiClient.allCountries()
                    .debug("Fetch all countries")
                    .map { .data($0) }
                    .asDriver(onErrorJustReturn: .error)
                    .startWith(.loading)
        }
        
        eventDriver = EventDriver(driver: driver)
        
        let countriesDataDriver = driver
            .map { event -> [CountryCellModel]? in
                switch event {
                case .data(let data):
                    let models = data.map { CountryCellModel(with: $0) }
                    return models
                default: return nil
                }
            }
            .filter { $0 != nil }
            .map { $0! }
        
        countriesList = countriesDataDriver.map { $0 }
        
        if let list = countriesList {
            presentDetails = cellDidSelect
                .withLatestFrom(list) { ($0, $1) }
                .map { $1[$0].name }
        }
    }
}
