//
//  LaunchScreenPresenter.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
import UIKit


class LoadingPresenter{
    
    let router: MainRouter = MainRouter()
    let interactor: AuthorizationInteractor = AuthorizationInteractor()
    
    func checkAuthorization(viewController: UIViewController){
        if interactor.isLoggedIn() == false {
            router.navigateToLogin(from: viewController)
        } else {
            router.navigateToMain(from: viewController)
        }
    }
    
}
