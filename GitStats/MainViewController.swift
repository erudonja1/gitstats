//
//  ViewController.swift
//  GitStats
//
//  Created by mac on 13/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import Charts
import UIKit

class MainViewController: BaseViewController, ChartViewDelegate, MainViewProtocol{
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
    
    var presenter: MainPresenter = MainPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.bounces = false
        
        self.setPresenter()
        self.setNavigationBar()
        self.setSegmentedControl()
        self.setSwipeGestures()
        
        self.lineChartView.delegate = self
        
        self.presenter.fetch()
    }
    
    override func viewDidLayoutSubviews() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let screenSize: CGRect = UIScreen.main.bounds
            lineCharWidthConstraint.constant = (screenSize.width / 2) - 50
            lineCharHorizontalConstraint.constant = -(lineCharWidthConstraint.constant/2)
            self.lineChartView.layoutIfNeeded()
        }
    }
    
    func segmentValueChanged(sender: AnyObject?){
        if presenter.hasLoadedData(){
            self.setNavigationBarColors()
            self.populateView()
        }
    }

    func populateView(){
        self.setContent()
        let selectedTab = self.segmentControl.selectedIndex
        let chartData = self.presenter.getDataChart(tab: selectedTab)
        self.setChartData(values: chartData)
        self.hideLoading()
    }
    
    func changeChartData(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                self.presenter.slideToIndex(places: 1, tab: segmentControl.selectedIndex)
                self.populateView()
            case UISwipeGestureRecognizerDirection.down:
                self.presenter.fetch()
            case UISwipeGestureRecognizerDirection.left:
                self.presenter.slideToIndex(places: -1, tab: segmentControl.selectedIndex)
                self.populateView()
            default:
                break
            }
        }
    }
    
    func setChartData(values: [StatisticUnit]) {
        let mainColor = segmentControl.colors[segmentControl.selectedIndex]
        
        // 1 - creating an array of data entries
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        for (i, _) in values.enumerated(){
            yVals1.append(ChartDataEntry(x: Double(i), y: Double(values[i].value)))
        }
        
        // 2 - create a data set with our array
        let set1: LineChartDataSet = LineChartDataSet(values: yVals1, label: "First Set")
        set1.axisDependency =  .right // Line will correlate with left axis values
        set1.setColor(mainColor.withAlphaComponent(0.5)) // our line's opacity is 50%
        set1.setCircleColor(mainColor) // our circle will be main colored
        set1.lineWidth = 2.0
        set1.cubicIntensity = 0.05
        set1.circleRadius = 2.0 // the radius of the node circle
        set1.fillAlpha = 65 / 255.0
        set1.mode = .cubicBezier
        set1.drawFilledEnabled = true
        set1.drawCircleHoleEnabled = true
        set1.fillColor = mainColor
        
        let gradColors = [UIColor.clear.cgColor, mainColor.cgColor]
        let colorLocations:[CGFloat] = [0.0, 1.0]
        if let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradColors as CFArray, locations: colorLocations) {
            set1.fill = Fill(linearGradient: gradient, angle: 90.0)
        }
        
        //3 - create an array to store our LineChartDataSets
        var dataSets : [LineChartDataSet] = [LineChartDataSet]()
        dataSets.append(set1)
        
        
        //4 - pass our months in for our x-axis label value along with our dataSets
        let valueNames = values.map({$0.key})
        let data: LineChartData = LineChartData(dataSets: dataSets)
        data.setValueTextColor(mainColor)
        
        //5 - finally set our data
        self.lineChartView.data = data
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:valueNames)
        // lineChartView.xAxis.granularity = 1
        
        // setting x axis
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView!.xAxis.drawGridLinesEnabled = false
        self.lineChartView.xAxis.spaceMin = 0
        self.lineChartView.xAxis.spaceMax = 0
        
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
        self.lineChartView!.chartDescription?.text = ""
        self.lineChartView!.noDataText = ""
        self.lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
    func setContent(){
        let tabIndex: Int = segmentControl.selectedIndex
        
        self.statisticsDate.text = self.presenter.getDate(tab: tabIndex)
        self.statisticsName.text = self.presenter.getName(tab: tabIndex)
        let totalCommits = self.presenter.getTotal(tab: tabIndex)
        let progress = self.presenter.getProgress(tab: tabIndex)
        let fractionalProgress = Float(progress) / Float(totalCommits)
        self.statisticsProgress.setProgress(fractionalProgress, animated: true)
        
        self.statisticsDescription.text = ContentService().getDescription(tab: tabIndex)
        self.statisticsSubtitle.text = ContentService().getSubTitle(tab: tabIndex)
        self.statisticsTitle.text = ContentService().getTitle(tab: tabIndex)
        self.statisticsTotal.text = String(progress)
    }
    
    func logoutClicked(){
        UIService().logoutMenu(title: "Are you sure?", buttonText: "Logout", buttonText2: "Analysis", viewController: self,  completion: {(result) in
            
            switch result {
            case .logout:
                self.presenter.logout(viewController: self)
            case .analysis:
                self.presenter.analyze(selectedIndex: self.segmentControl.selectedIndex)
            case .cancel:
                break
            }
            
        })
    }
    
    private func setPresenter(){
        self.presenter.output = self as MainViewProtocol
    }

    private func setSegmentedControl(){
        segmentControl.items = ["Day", "Week", "Month"]
        segmentControl.colors = [UIColor(string: "#007AFF"), UIColor(string:"#00C951"), UIColor(string: "#FFCC33")]
        segmentControl.unselectedLabelColor = UIColor.lightGray
        segmentControl.font = UIFont(name: "HelveticaNeue", size: 15)
        segmentControl.selectedIndex = 0
    }
    
    private func setNavigationBar(){
        let logout = UIBarButtonItem(image: UIImage(named: "Cogwheel"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(MainViewController.logoutClicked))
        logout.tintColor = UIColor.white
        navigationItem.rightBarButtonItems = [logout]
        
        self.setNavigationBarColors()
        
        appTitle.title = "GitStats"
        segmentControl.addTarget(self, action: #selector(segmentValueChanged(sender:)), for: .valueChanged)
    }
    
    private func setNavigationBarColors(){
        if let navigationController = self.navigationController {
            navigationController.navigationBar.barTintColor = segmentControl.colors[segmentControl.selectedIndex]
            navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
    }
    
    private func setSwipeGestures(){
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
    
    func show(analysisResult: String){
         UIService().showAlert(title: "Analysis", message: analysisResult, buttonText: "Close", viewController: self)
    }
    
}

