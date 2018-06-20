//
//  LaunchScreenViewController.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {
    
    @IBOutlet weak var AppTitle: UILabel!
    
    var presenter: LoadingPresenter = LoadingPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.set("GitStats", to: AppTitle)
        self.setStatusBar()
        
        //when animations are finished, do segue and go to initial view
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(LoadingViewController.checkUser), userInfo: nil, repeats: false)
    }
    
    private func setStatusBar(){
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func checkUser(){
        self.presenter.checkAuthorization(viewController: self)
    }
    
}
