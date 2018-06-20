//
//  BaseViewController.swift
//  GitStats
//
//  Created by mac on 20/06/2016.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    
    func set(_ heading: String, to titleLabel: UILabel){
        let myString: NSString = heading as NSString
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: nil)
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 45.0)!, range:  NSRange(location:0,length:3))
        titleLabel.attributedText = myMutableString
    }
    
    
    func showError(message: String){
        UIService().showAlert(title: "Error", message: message, buttonText: "Dismiss", viewController: self)
    }
    
    func showLoading(message: String){
        UIService().showLoading(forView: self.view, message: message)
    }
    
    func hideLoading(){
        UIService().hideLoading(forView: self.view)
    }
}
