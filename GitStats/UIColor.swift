//
//  UIColor.swift
//  GitStats
//
//  Created by mac on 04/12/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import UIKit
extension UIColor {
    // Initialiser for strings of format '#_RED_GREEN_BLUE_'
    convenience init(hex: String?) {
        var color: String = ""
        if hex == nil { color = "#000000"} else { color = hex!}
        
        let redRange    = Range<String.Index>(color.startIndex.advancedBy(1) ..< color.startIndex.advancedBy(3))
        let greenRange  = Range<String.Index>(color.startIndex.advancedBy(3) ..< color.startIndex.advancedBy(5))
        let blueRange   = Range<String.Index>(color.startIndex.advancedBy(5) ..< color.startIndex.advancedBy(7))
        
        var red     : UInt32 = 0
        var green   : UInt32 = 0
        var blue    : UInt32 = 0
        
        NSScanner(string: color.substringWithRange(redRange)).scanHexInt(&red)
        NSScanner(string: color.substringWithRange(greenRange)).scanHexInt(&green)
        NSScanner(string: color.substringWithRange(blueRange)).scanHexInt(&blue)
        
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: 1
        )
    }
}
