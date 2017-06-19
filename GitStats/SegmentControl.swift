//
//  SegmentControl.swift
//  GitStats
//
//  Created by mac on 24/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SegmentControl: UIControl {
    
    private var labels = [UILabel]()
    var thumbView = UIView()
    
    var items: [String] = ["Item 1", "Item 2", "Item 3"] {  //default
        didSet {
            setupLabels()
        }
    }
    
    var colors: [UIColor] = [UIColor.blue, UIColor.green, UIColor.yellow] // default
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = UIColor.gray {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var font : UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.borderWidth = 0
        backgroundColor = UIColor.clear
        setupLabels()
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
        insertSubview(thumbView, at: 0)
    }
    
    func setupLabels(){
        for label in labels {
            label.removeFromSuperview()
        }
        labels.removeAll(keepingCapacity: true)
        for index in 1...items.count {
            let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: 70, height: 40))
            label.text = items[index - 1]
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = UIFont(name: "System", size: 15)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(items: labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
        var selectFrame = self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor
        displayNewSelectedIndex()
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        return false
    }
    
    func displayNewSelectedIndex(){
        //creates gray underline for all items
        let underlineGrayBorder = CALayer()
        underlineGrayBorder.backgroundColor = unselectedLabelColor.cgColor
        
        let underlineGrayBorderXstart = (UIScreen.main.bounds.width - self.bounds.width) / 2
        let underlineGrayBorderYstart = thumbView.frame.size.height - 3
        let underlineGrayBorderHeight = CGFloat(3)
        let underlineGrayBorderWidth = self.bounds.width + (2 * underlineGrayBorderXstart)
        
        underlineGrayBorder.frame = CGRect.init(x: -underlineGrayBorderXstart, y: underlineGrayBorderYstart, width: underlineGrayBorderWidth, height: underlineGrayBorderHeight)
        layer.addSublayer(underlineGrayBorder)

        //reset of textColor of all items
        for (_, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
            item.backgroundColor = UIColor.clear
            // creates gray line on right side of item if it is not the last one
            if item != labels.last {
                let rightlineBorder = CALayer()
                rightlineBorder.backgroundColor = unselectedLabelColor.cgColor
                rightlineBorder.frame = CGRect.init(x:thumbView.frame.width - 2, y: 15, width: 1, height: item.intrinsicContentSize.height + 10)
                item.layer.sublayers?.removeAll()
                item.layer.addSublayer(rightlineBorder)
            }
        }
        
        let label = labels[selectedIndex]
        label.textColor = colors[selectedIndex]
        
        //creates colorful underline for selected item
        let underlineBorder = CALayer()
        underlineBorder.backgroundColor = colors[selectedIndex].cgColor
        underlineBorder.frame = CGRect.init(x:0, y:thumbView.frame.size.height - 3, width: label.frame.width, height: 3)
        thumbView.layer.sublayers?.removeAll()
        thumbView.layer.addSublayer(underlineBorder)
        
        // setting the selected and ordering view layouts
        self.thumbView.frame = label.frame
        self.bringSubview(toFront: self.thumbView)
        self.bringSubview(toFront: label)
    }
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
        _ = mainView.constraints
        
        for (index, button) in items.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: nextButton, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: prevButton, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        thumbView.backgroundColor = thumbColor
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
    func slide(position:Int){
        if (selectedIndex != 0 && position < 0) || (selectedIndex != (items.count-1) && position > 0){
            selectedIndex = selectedIndex + position
        }
    }
    
}
