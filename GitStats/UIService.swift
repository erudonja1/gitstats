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
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func questionMenu(title:String, buttonText: String, buttonText2: String, viewController: UIViewController, completion: (String) -> ()){
        
        let alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.Default, handler: { action in
            completion(buttonText)
        }))
        alert.addAction(UIAlertAction(title: buttonText2, style: UIAlertActionStyle.Default, handler: { action in
            completion(buttonText2)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { action in
            completion("Cancel")
        }))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    //Loading bar that indicating: something is happening, with dynamic content
    class func showLoading(forView :UIView, message: String) {
        let hud = MBProgressHUD.showHUDAddedTo(forView, animated: true)
        hud.labelText = message
    }
    // Loading bar dissapears
    class func hideLoading(forView :UIView) {
        MBProgressHUD.hideAllHUDsForView(forView, animated: true)
    }
    
    
}