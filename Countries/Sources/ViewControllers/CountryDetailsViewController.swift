//
//  CountryDetailsViewController.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CountryDetailsViewController: UITableViewController, LoadableViewController {
    
    typealias ViewModelType = CountryDetailsViewModel
    
    var countryName: String?
    
    var disposeBag = DisposeBag()
    var viewModel: ViewModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = refreshBarButtonItem
        
        configureViewModel()

        bind()
    }
    
    func configureViewModel() {
        guard let name = countryName else { return }
        let refreshDriver = refreshBarButtonItem.rx.tap.asDriver()
        viewModel = CountryDetailsViewModel(apiClient: API.shared,
                                            countryName: name,
                                            refreshDriver: refreshDriver)
        setup(with: viewModel)
    }
    
    func bind() {
        guard let viewModel = viewModel else { return }
        
        // ViewController's title
        viewModel.name?
            .asDriver()
            .drive(self.rx.title)
            .disposed(by: disposeBag)
        
        // Country name label
        viewModel.name?
            .asDriver()
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Country capital label
        viewModel.capital?
            .asDriver()
            .drive(capitalLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Country currencies label
        viewModel.currencies?
            .asDriver()
            .drive(currenciesLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Private
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var capitalLabel: UILabel!
    @IBOutlet private weak var currenciesLabel: UILabel!
    
    private lazy var refreshBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: nil,
            action: nil
        )
    }()
}
