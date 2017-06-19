//
//  UIService.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit
import MBProgressHUD

class UIService {

    //Showing message alert with dynamic content
    class func showAlert(title:String, message: String, buttonText: String, viewController: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func questionMenu(title:String, buttonText: String, buttonText2: String, viewController: UIViewController, completion: @escaping (String) -> ()){
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: { action in
            completion(buttonText)
        }))
        alert.addAction(UIAlertAction(title: buttonText2, style: UIAlertActionStyle.default, handler: { action in
            completion(buttonText2)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
            completion("Cancel")
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
    
    //Loading bar that indicating: something is happening, with dynamic content
    class func showLoading(forView :UIView, message: String) {
        let hud = MBProgressHUD.showAdded(to: forView, animated: true)
        hud.label.text = message
    }
    // Loading bar dissapears
    class func hideLoading(forView :UIView) {
        MBProgressHUD.hide(for: forView, animated: true)
        //MBProgressHUD.hideAllHUDs(for: forView, animated: true)
    }
    
    
}
