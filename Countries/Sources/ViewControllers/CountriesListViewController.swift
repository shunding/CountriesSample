//
//  ViewController.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CountriesListViewController: UITableViewController, LoadableViewController {
    typealias ViewModelType = CountriesListViewModel
    
    @IBOutlet private weak var refreshButton: UIBarButtonItem!

    private let cellIdentifier = "CountryCell"
    
    private var selectedCountryName: String?
    
    var viewModel: ViewModelType?
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = nil
        tableView.dataSource = nil
        
        configureViewModel()
        bind()
        
        title = "All Countries"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier == "Details",
            let controller = segue.destination as? CountryDetailsViewController,
            let countryName = selectedCountryName {
            controller.countryName = countryName
        }
    }
    
    func configureViewModel() {
        let refreshDriver = refreshButton.rx.tap.asDriver()
        viewModel = CountriesListViewModel(apiClient: API.shared,
                                           refreshDriver: refreshDriver)
        setup(with: viewModel)
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.cellDidSelect)
            .disposed(by: disposeBag)
        
        viewModel.isLoading?
            .map { !$0 }
            .drive(refreshButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.countriesList?
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { i, model, cell in
                cell.textLabel?.text = model.name
                cell.detailTextLabel?.text = model.population
            }.disposed(by: disposeBag)
        
        viewModel.presentDetails?.subscribe(onNext: { [weak self] countryName in
            self?.selectedCountryName = countryName
            self?.performSegue(withIdentifier: "Details", sender: self)
        }).disposed(by: disposeBag)
    }
}

