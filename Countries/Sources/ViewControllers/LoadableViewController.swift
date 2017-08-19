//
//  LoadableViewController.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD

/// Generic protocol used for creating view controllers
/// driven by ```LoadableViewModel```s. Handles loading
/// events according to view model's loading state.
protocol LoadableViewController {
    associatedtype ViewModelType: LoadableViewModel
    var disposeBag: DisposeBag { get set }
    func bind()
    func configureViewModel()
    func setup(with model: ViewModelType?)
}

extension LoadableViewController where Self: UIViewController {
    func setup(with model: ViewModelType?) {
        guard let loading = model?.isLoading,
            let failed = model?.hasFailed else { return }
        
        // If loading or error event occured - drive the HUD.
        Driver.combineLatest(loading,failed) { $0 || $1 }
            .distinctUntilChanged()
            .drive(HUD.asObserver)
            .disposed(by: disposeBag)
    }
}
