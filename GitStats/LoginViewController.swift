//
//  LoginViewController.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController, UITextFieldDelegate, LoginProtocol{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var AppTitle: UILabel!
    
    var presenter: LoginPresenter = LoginPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.bounces = false
        self.navigationController?.isNavigationBarHidden = true
        
        self.set("GitStats", to: AppTitle)
        self.setInputFields()
        self.setLoginButton()
        self.setPresenter()
    }
    
    private func setPresenter(){
        self.presenter.output = self as LoginProtocol
    }
    
    private func setInputFields(){
        username.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        password.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        url.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
    }
    
    private func setLoginButton(){
        loginButton.backgroundColor = UIColor.clear
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func login(sender: UIButton) {
        if let urlText = url.text, let usernameText = username.text, let passwordText = password.text {
            presenter.login(username: usernameText, password: passwordText, fullUrl: urlText, viewController: self)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
