//
//  MainViewControllerChart.swift
//  GitStats
//
//  Created by mac on 19/06/17.
//  Copyright © 2017 Elvis Studio. All rights reserved.
//

import Charts
import UIKit

extension MainViewController{

    func changeChartData(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                slide(places: 1, tab: segmentControl.selectedIndex)
                setContent()
                self.setChartData(values: self.getDataChart(tab: self.segmentControl.selectedIndex, index: self.selectedIndex))
            case UISwipeGestureRecognizerDirection.down:
                read()
            case UISwipeGestureRecognizerDirection.left:
                slide(places: -1, tab: segmentControl.selectedIndex)
                setContent()
                self.setChartData(values: self.getDataChart(tab: self.segmentControl.selectedIndex, index: self.selectedIndex))
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
        self.statisticsDate.text = getDate(tab: segmentControl.selectedIndex, index: self.selectedIndex)
        self.statisticsName.text = getName(tab: segmentControl.selectedIndex, index: self.selectedIndex)
        let totalCommits = getTotal(tab: segmentControl.selectedIndex)
        let progress = getProgress(tab: segmentControl.selectedIndex, index: self.selectedIndex)
        let fractionalProgress = Float(progress) / Float(totalCommits)
        self.statisticsProgress.setProgress(fractionalProgress, animated: true)
        
        self.statisticsDescription.text = ContentService().getDescription(tab: segmentControl.selectedIndex)
        self.statisticsSubtitle.text = ContentService().getSubTitle(tab: segmentControl.selectedIndex)
        self.statisticsTitle.text = ContentService().getTitle(tab: segmentControl.selectedIndex)
        self.statisticsTotal.text = String(progress)
    }
    
}
