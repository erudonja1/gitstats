//
//  MainViewControllerExtension.swift
//  GitStats
//
//  Created by mac on 19/06/17.
//  Copyright © 2017 Elvis Studio. All rights reserved.
//
import Charts
import UIKit

extension MainViewController{


    func initArrays(){
        days = []
        weeks = []
        months = []
    }
    func initSegmentedControl(){
        segmentControl.items = ["Day", "Week", "Month"]
        segmentControl.colors = [UIColor(string: "#007AFF"), UIColor(string:"#00C951"), UIColor(string: "#FFCC33")]
        segmentControl.unselectedLabelColor = UIColor.lightGray
        segmentControl.font = UIFont(name: "HelveticaNeue", size: 15)
        segmentControl.selectedIndex = 0
    }
    func initNavigationBar(){
        let logout = UIBarButtonItem(image: UIImage(named: "Cogwheel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainViewController.doLogout))
        logout.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [logout]
        appTitle.title = "GitStats"
        navigationController!.navigationBar.barTintColor = segmentControl.colors[segmentControl.selectedIndex]
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
    }
    func initSwipes(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(changeChartData(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(changeChartData(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(changeChartData(gesture:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.segmentControl.addGestureRecognizer(swipeDown)
        scrollView.panGestureRecognizer.require(toFail: swipeDown)
    }
    
    func read(){
        StatsService().getStatsPerWeekAndMonth(forView: self.view) { (result, msg, weeks, months) -> () in
            if result == true {
                StatsService().getStatsPerDays(forView: self.view) { (res, ms, days) -> () in
                    if res == true {
                        self.weeks = weeks
                        self.months = months
                        self.days = days
                        
                        self.setContent()
                        self.setChartData(values: self.getDataChart(tab: self.segmentControl.selectedIndex, index: 0))
                    }
                    else{
                        UIService.showAlert(title: "Error", message: ms, buttonText: "Ok", viewController: self)
                    }
                }
            }
            else{
                UIService.showAlert(title: "Error", message: msg, buttonText: "Ok", viewController: self)
            }
        }
    }    
    
}
