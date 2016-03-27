//
//  LaunchScreenViewController.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit
import Spring
import FontAwesome_swift

class LaunchScreenViewController: UIViewController {
    

    @IBOutlet weak var AppTitle: SpringLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let myString:NSString = "GitStats"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: nil)
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 45.0)!, range:  NSRange(location:0,length:3))
        AppTitle.attributedText = myMutableString
        
        //come in
        AppTitle.animation = "fadeIn";
        AppTitle.duration = 3;
        AppTitle.autohide = true;
        AppTitle.animate();

        //when animations are finished, do segue and go to initial view
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "doSegue", userInfo: nil, repeats: false)
    }
    
    func doSegue(){
        if AuthorizationService.isCached() == false {
            self.performSegueWithIdentifier("showLoginView", sender: self)
        }else{
            self.performSegueWithIdentifier("showMainView", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
