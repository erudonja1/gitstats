//
//  ViewController.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import Charts
import UIKit

class MainViewController: UIViewController, ChartViewDelegate{
    @IBOutlet weak var appTitle: UINavigationItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var segmentControl: SegmentControl!
    @IBOutlet weak var statisticsName: UILabel!
    @IBOutlet weak var statisticsProgress: UIProgressView!
    @IBOutlet weak var statisticsDate: UILabel!
    @IBOutlet weak var statisticsTitle: UILabel!
    @IBOutlet weak var statisticsSubtitle: UILabel!
    @IBOutlet weak var statisticsDescription: UITextView!
    
    @IBOutlet weak var lineCharWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lineCharHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var statisticsTotal: UILabel!
    
    var days: [DayStatistics] = []
    var weeks: [WeekStatistics] = []
    var months: [MonthStatistics] = []
    var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.bounces = false
        
        initArrays()
        initSegmentedControl()
        initNavigationBar()
        initSwipes()
        
        self.lineChartView.delegate = self
        read()
    }
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let screenSize: CGRect = UIScreen.main.bounds
            lineCharWidthConstraint.constant = (screenSize.width / 2) - 50
            lineCharHorizontalConstraint.constant = -(lineCharWidthConstraint.constant/2)
            self.lineChartView.layoutIfNeeded()
        }
    }

    func doLogout(){
        UIService.questionMenu(title: "Are you sure?", buttonText: "Logout", buttonText2: "Analysis", viewController: self,  completion: {(result) in
            
            if result == "Logout" {
                AuthorizationService.clearToken()
                self.performSegue(withIdentifier: "showLoginView", sender: self)
            }
            if result == "Analysis" {
                UIService.showLoading(forView: self.view, message: "analyzing...")
                let analysisResult = AnalysisService.get(inputs: self.getDataChart(tab: self.segmentControl.selectedIndex, index: 0), tab: self.segmentControl.selectedIndex)
                
                UIService.hideLoading(forView: self.view)
                UIService.showAlert(title: "Analysis", message: analysisResult, buttonText: "Close", viewController: self)
            }
        })
    }
    
    func segmentValueChanged(sender: AnyObject?){
        if weeks.count != 0 || months.count != 0{
            navigationController!.navigationBar.barTintColor = segmentControl.colors[segmentControl.selectedIndex]
            self.selectedIndex = 0
            setContent()
            self.setChartData(values: self.getDataChart(tab: self.segmentControl.selectedIndex, index: 0))
        }else{
            UIService.showAlert(title: "Loading", message: "Please wait, loading data...", buttonText: "Ok", viewController: self)
        }
    }


}

