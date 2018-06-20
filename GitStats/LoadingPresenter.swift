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
    
    func checkAuthorization(viewController: UIViewController){
        if AuthService.sharedInstance.isLoggedIn() == false {
            MainRouter().navigateToLogin(from: viewController)
        } else {
            MainRouter().navigateToMain(from: viewController)
        }
    }
    
}
