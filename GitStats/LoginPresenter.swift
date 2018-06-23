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

class LoginPresenter: AuthorizationProtocol {

    weak var output: LoginProtocol?
    
    let router: MainRouter = MainRouter()
    let interactor: AuthorizationInteractor = AuthorizationInteractor()

    
    func login(username: String, password: String, fullUrl: String){
        let words = fullUrl.characters.split{$0 == "/"}.map(String.init)
        if words.count >= 2 {
            let baseUrl = words[words.count-2] + "/" + words[words.count-1]
            // 1. get the authorization token
            self.getToken(username: username, password: password, baseUrl: baseUrl)
            
        }else {
            output?.showError(message: "Wrong repo path format.")
        }
    }
    
    private func getToken(username: String, password: String, baseUrl: String){
        self.output?.showLoading(message: "Going inside of the world of magic...")
        self.interactor.presenter = self as AuthorizationProtocol
        interactor.login(username: username, password: password, rpath: baseUrl)
    }
    
    
    func userAuthorized(repoPath: String) {
        self.output?.hideLoading()
        self.output?.showLoading(message: "Fetching repository data...")
        // 2. get infromation about repository
        self.interactor.getRepoInfo(rpath: repoPath)
    }
    
    func userNotAuthorized(message: String) {
        self.output?.hideLoading()
        self.output?.showError(message: "Wrong credentials.")
    }
    
    func repoInfoFetched(){
        self.output?.hideLoading()
        if let parent = output as? UIViewController {
            self.router.navigateToMain(from: parent)
        }
    }
    
    func repoInfoNotFetched(message: String){
        self.output?.hideLoading()
        self.output?.showError(message: message)
    }

}
