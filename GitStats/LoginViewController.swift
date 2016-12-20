//
//  LoginViewController.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit
import FontAwesome_swift

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var url: UITextField!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var AppTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.bounces = false
        self.navigationController?.navigationBarHidden = true
        let myString:NSString = "GitStats"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: nil)
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 45.0)!, range:  NSRange(location:0,length:3))
        AppTitle.attributedText = myMutableString
        
        username.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        password.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        url.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
        
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        /* self.scrollView.contentSize.height = self.view.bounds.height + (100000 / self.view.bounds.height); //as the screen gets bigger, scroll height will be smaller :)*/
    }
    
    @IBAction func login(sender: UIButton) {
        //take url repo/owner
        let url_text = url.text! as String
        let words = url_text.characters.split{$0 == "/"}.map(String.init)
        if words.count >= 2 {
            let repo_path = words[words.count-2] + "/" + words[words.count-1]
            AuthorizationService.getToken(username.text!, password: password.text!, rpath: repo_path, forView: self.view, completionHandler: {(str, msg) in
                if str == true {
                    self.performSegueWithIdentifier("showMainView", sender: self)
                } else {
                    UIService.showAlert("Error", message: msg, buttonText: "Dismiss", viewController: self)
                }
            })
        }else {
            UIService.showAlert("Error", message: "Wrong credentials", buttonText: "Dismiss", viewController: self)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
