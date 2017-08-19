//
//  PKHUD+Rx.swift
//  Countries
//
//  Created by Alex Drozhak on 8/19/17.
//  Copyright © 2017 Alex Drozhak. All rights reserved.
//

import PKHUD
import RxSwift

extension HUD {
    
    /// This static property extends HUD object bo be bindable/drivable
    /// within Rx ecosystem. Could be used as 
    /// ```...drive(HUD.asObserver).disposed(by...```
    /// Can react on loading and error events appropriately.
    /// Uses ```UIApplication```'s network activity indicator and
    /// PKHUD as indicators.
    public static var asObserver: AnyObserver<Bool> {
        return AnyObserver { event in
            MainScheduler.ensureExecutingOnScheduler()
            
            let errorPayload = HUDContentType.labeledError(title: "Error",
                                                           subtitle: "Try again later.")
            
            switch event {
            case .next(let inProgress):
                UIApplication.shared.isNetworkActivityIndicatorVisible = inProgress
                if inProgress {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            case .error:
                HUD.flash(errorPayload, delay: 2)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .completed:
                HUD.hide()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
}
