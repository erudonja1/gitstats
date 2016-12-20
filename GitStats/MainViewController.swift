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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.bounces = false
        let logout = UIBarButtonItem(image: UIImage(named: "Cogwheel"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MainViewController.doLogout))
        logout.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItems = [logout]
        appTitle.title = "GitStats"
        segmentControl.items = ["Day", "Week", "Month"]
        segmentControl.colors = [UIColor(hex: "#007AFF"), UIColor(hex:"#00C951"), UIColor(hex: "#FFCC33")]
        segmentControl.unselectedLabelColor = UIColor.lightGrayColor()
        segmentControl.font = UIFont(name: "HelveticaNeue", size: 15)
        segmentControl.selectedIndex = 0
        
        navigationController!.navigationBar.barTintColor = segmentControl.colors[segmentControl.selectedIndex]
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        segmentControl.addTarget(self, action: #selector(MainViewController.segmentValueChanged(_:)), forControlEvents: .ValueChanged)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.changeChartData(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.changeChartData(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.changeChartData(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        
        self.segmentControl.addGestureRecognizer(swipeDown)
        
        scrollView.panGestureRecognizer.requireGestureRecognizerToFail(swipeDown)
        
        self.lineChartView.delegate = self
        
        initChart()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doLogout(){
        UIService.questionMenu("Are you sure?", buttonText: "Logout", buttonText2: "Analysis", viewController: self,  completion: {(result) in
            
            if result == "Logout" {
                AuthorizationService.clearToken()
                self.performSegueWithIdentifier("showLoginView", sender: self)
            }
            if result == "Analysis" {
                UIService.showLoading(self.view, message: "analyzing...")
                // Testing purposes
                var testers: [StatisticUnit] = []
                var i = 1
                repeat {
                    var item = StatisticUnit()
                    item.value = 100
                    testers.append(item)
                    i = i + 1
                } while i < 10000
                let analysisResult = AnalysisServiceNew.get(testers, tab: 1)
                
                
               // let analysisResult = AnalysisServiceNew.get(ContentService.getDataChart(self.segmentControl.selectedIndex, index: ContentService.selectedIndex), tab: self.segmentControl.selectedIndex)
                UIService.hideLoading(self.view)
                UIService.showAlert("Analysis", message: analysisResult, buttonText: "Close", viewController: self)
            }
        })
    }
    func initChart(){
        StatsService.getStatsPerWeekAndMonth(self.view) { (result, msg) -> () in
            if result == true {
                StatsService.getStatsPerDays(self.view) { (res, ms) -> () in
                    if res == true {
                        self.setStaticContent()
                        self.setChartData(ContentService.getDataChart(self.segmentControl.selectedIndex, index: 0))
                    }
                    else{
                        UIService.showAlert("Error", message: ms, buttonText: "Ok", viewController: self)
                    }
                }
            }
            else{
                UIService.showAlert("Error", message: msg, buttonText: "Ok", viewController: self)
            }
        }
        
    }
    func setChartData(values: [StatisticUnit]) {
        let mainColor = segmentControl.colors[segmentControl.selectedIndex]
        
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for (i, _) in values.enumerate(){
            yVals1.append(ChartDataEntry(value: Double(values[i].value), xIndex: i))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(yVals: yVals1, label: "First Set")
        set1.axisDependency =  .Right // Line will correlate with left axis values
        set1.setColor(mainColor.colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(mainColor) // our circle will be main colored
        set1.lineWidth = 2.0
        set1.cubicIntensity = 0.05
        set1.circleRadius = 2.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.drawCubicEnabled = true
        set1.drawFilledEnabled = true
        set1.drawCircleHoleEnabled = true
        set1.fillColor = mainColor
        
        let gradColors = [UIColor.clearColor().CGColor, mainColor.CGColor]
        let colorLocations:[CGFloat] = [0.0, 1.0]
        if let gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), gradColors, colorLocations) {
            set1.fill = ChartFill(linearGradient: gradient, angle: 90.0)
        }
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let valueNames = values.map({$0.key})
        let data: LineChartData = LineChartData(xVals: valueNames, dataSets: dataSets)
        data.setValueTextColor(mainColor)
        
        //5 - finally set our data
        self.lineChartView.data = data
        
        // setting x axis
        self.lineChartView.xAxis.labelPosition = .Bottom
        self.lineChartView!.xAxis.drawGridLinesEnabled = false
        self.lineChartView.xAxis.spaceBetweenLabels = 0
        //self.lineChartView.xAxis.setLabelsToSkip(values.count-2)
        
        
        //setting y axis left
        self.lineChartView.leftAxis.enabled = false
        self.lineChartView.leftAxis.drawLabelsEnabled = false
        self.lineChartView.leftAxis.drawTopYLabelEntryEnabled = false
        self.lineChartView.leftAxis.drawAxisLineEnabled = false
        
        //setting x axis right
        self.lineChartView.rightAxis.enabled = true
        self.lineChartView!.rightAxis.drawGridLinesEnabled = true
        self.lineChartView.rightAxis.drawLabelsEnabled = false
        self.lineChartView!.rightAxis.drawAxisLineEnabled = false
        
        self.lineChartView.legend.enabled = false
        self.lineChartView!.noDataText = "No data"
        self.lineChartView!.descriptionText = ""
        self.lineChartView!.noDataTextDescription = ""
        self.lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }

    
    func segmentValueChanged(sender: AnyObject?){
        if StatsService.weeks.count != 0 || StatsService.months.count != 0{
            navigationController!.navigationBar.barTintColor = segmentControl.colors[segmentControl.selectedIndex]
            ContentService.selectedIndex = 0
            setStaticContent()
            self.setChartData(ContentService.getDataChart(self.segmentControl.selectedIndex, index: 0))
        }else{
            UIService.showAlert("Loading", message: "Please wait, loading data...", buttonText: "Ok", viewController: self)
        }
    }
    func setStaticContent(){
        self.statisticsDate.text = ContentService.getDateContent(segmentControl.selectedIndex, index: ContentService.selectedIndex)
        self.statisticsDescription.text = ContentService.getDescriptionContent(segmentControl.selectedIndex)
        self.statisticsName.text = ContentService.getNameContent(segmentControl.selectedIndex, index: ContentService.selectedIndex)
        let totalCommits = ContentService.getTotalContent(segmentControl.selectedIndex)
        let progress = ContentService.getProgressContent(segmentControl.selectedIndex, index: ContentService.selectedIndex)
        let fractionalProgress = Float(progress) / Float(totalCommits)
        self.statisticsProgress.setProgress(fractionalProgress, animated: true)
        self.statisticsSubtitle.text = ContentService.getSubTitleContent(segmentControl.selectedIndex)
        self.statisticsTitle.text = ContentService.getTitleContent(segmentControl.selectedIndex)
        self.statisticsTotal.text = String(progress)
    }
    
    func changeChartData(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                ContentService.slide(1, tab: segmentControl.selectedIndex)
                setStaticContent()
                self.setChartData(ContentService.getDataChart(self.segmentControl.selectedIndex, index: ContentService.selectedIndex))
            case UISwipeGestureRecognizerDirection.Down:
                initChart()
            case UISwipeGestureRecognizerDirection.Left:
                ContentService.slide(-1, tab: segmentControl.selectedIndex)
                setStaticContent()
                self.setChartData(ContentService.getDataChart(self.segmentControl.selectedIndex, index: ContentService.selectedIndex))
            default:
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            lineCharWidthConstraint.constant = (screenSize.width / 2) - 50
            lineCharHorizontalConstraint.constant = -(lineCharWidthConstraint.constant/2)
            self.lineChartView.layoutIfNeeded()
        }
    }
    
    
    
    
}

