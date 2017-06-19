//
//  LaunchScreenViewController.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    

    @IBOutlet weak var AppTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let myString:NSString = "GitStats"
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: nil)
        myMutableString.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Bold", size: 45.0)!, range:  NSRange(location:0,length:3))
        AppTitle.attributedText = myMutableString

        //when animations are finished, do segue and go to initial view
        _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(LaunchScreenViewController.doSegue), userInfo: nil, repeats: false)
    }
    
    func doSegue(){
        if AuthorizationService.isCached() == false {
            self.performSegue(withIdentifier: "showLoginView", sender: self)
        }else{
            self.performSegue(withIdentifier: "showMainView", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
