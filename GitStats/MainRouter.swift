//
//  LoadingRouter.swift
//  GitStats
//
//  Created by mac on 20/06/2016.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import UIKit
import Foundation

class MainRouter {
    
    func navigateToMain(from controller: UIViewController?) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyBoard.instantiateInitialViewController(), let controller = controller, let navigation = controller.navigationController{
            navigation.present(vc, animated: true)
        }
    }
    
    func navigateToLogin(from controller: UIViewController?) {
        let storyBoard = UIStoryboard(name: "Login", bundle: nil)
        if let vc = storyBoard.instantiateInitialViewController(), let navigation: UINavigationController = controller?.navigationController{
            navigation.present(vc, animated: true)
        }
    }
    
}
