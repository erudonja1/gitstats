//
//  LoginPresenter.swift
//  GitStats
//
//  Created by mac on 20/06/2016.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit

protocol LoginProtocol: class {
    func showLoading(message: String)
    func hideLoading()
    func showError(message: String)
}

class LoginPresenter {
    
    weak var output: LoginProtocol?
    
    func login(username: String, password: String, fullUrl: String, viewController: LoginViewController){
        let words = fullUrl.characters.split{$0 == "/"}.map(String.init)
        if words.count >= 2 {
            let baseUrl = words[words.count-2] + "/" + words[words.count-1]
            // 1. get the authorization token
            self.getToken(username: username, password: password, baseUrl: baseUrl, viewController: viewController)
            
        }else {
            output?.showError(message: "Wrong repo path format.")
        }
    }
    
    private func getToken(username: String, password: String, baseUrl: String, viewController: LoginViewController){
        self.output?.showLoading(message: "Going inside of the world of magic...")
        AuthService.sharedInstance.getToken(username: username, password: password, rpath: baseUrl, completionHandler: {(succeeded, msg) in
            self.output?.hideLoading()
            
            if succeeded {
                // 2. get infromations about repository
                self.getRepoInfo(baseUrl: baseUrl, viewController: viewController)
            } else {
                self.output?.showError(message: "Wrong credentials.")
            }
        })
    }
    
    private func getRepoInfo(baseUrl: String, viewController: LoginViewController){
        self.output?.showLoading(message: "Fetching repository data...")
        AuthService.sharedInstance.getRepoInfo(rpath: baseUrl, completionHandler: {(succeeded, msg) in
            self.output?.hideLoading()
            
            if succeeded {
                MainRouter().navigateToMain(from: viewController)
            } else {
                self.output?.showError(message: msg)
            }
        })
    }
}
