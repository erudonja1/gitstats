//
//  MainPresenter.swift
//  GitStats
//
//  Created by mac on 20/06/2016.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import UIKit
import Foundation

protocol MainViewProtocol: class {
    func showLoading(message: String)
    func hideLoading()
    func show(analysisResult: String)
    func populateView()
    func showError(message: String)
}


class MainPresenter {
    
    weak var output: MainViewProtocol?
    
    var days: [DayStatistics]
    var weeks: [WeekStatistics]
    var months: [MonthStatistics]
    private var selectedIndex: Int = 0
    
    init() {
        days = []
        weeks = []
        months = []
    }
    
    func fetch(){
        // 1. first fetch for weeks and months, and if it succeeded, fetch for days
        self.fetchStatsForWeeks()
    }
    
    func logout(viewController: MainViewController){
        AuthService.sharedInstance.clearToken()
        MainRouter().navigateToLogin(from: viewController)
    }
    
    func analyze(selectedIndex: Int?){
        self.output?.showLoading(message: "analyzing...")
        
        let selectedTabIndex = selectedIndex ?? 0
        let chartData = self.getDataChart(tab: selectedTabIndex)
        let analysisResult = AnalysisService().get(inputs: chartData, tab: selectedTabIndex)
        
        self.output?.hideLoading()
        self.output?.show(analysisResult: analysisResult)
        
    }
    
    func hasLoadedData() -> Bool {
        return !weeks.isEmpty || !months.isEmpty
    }
    
    func getDataChart(tab: Int) -> [StatisticUnit]{
        switch tab {
        case 0:
            return days[selectedIndex].hourStatistics
        case 1:
            return weeks[selectedIndex].weekDayStatistics
        case 2:
            for (ind, _)  in months[selectedIndex].dayStatistics.enumerated() {
                months[selectedIndex].dayStatistics[ind].key = Date().getReadableDateDay(date: months[selectedIndex].dayStatistics[ind].date)
            }
            return months[selectedIndex].dayStatistics
        default:
            print("Error getting data for chart view")
            return []
        }
    }
    
    func getDate(tab: Int) -> String{
        switch tab {
        case 0:
            return ""
        case 1:
            if weeks.count > 0
            {
                return Date().getReadableDateMonth(date: weeks[selectedIndex].fromDate as Date)
            }else {
                return ""
            }
        case 2:
            if months.count > 0
            {
                return  Date().getReadableDateYear(date: months[selectedIndex].date as Date)
            }else {
                return ""
            }
        default:
            print("Error getting date readable name for statistics date")
            return ""
        }
    }
    
    func getProgress(tab: Int) -> Int{
        switch tab {
        case 0:
            return days[selectedIndex].hourStatistics.reduce(0,{$0 + $1.value})
        case 1:
            return weeks[selectedIndex].weekDayStatistics.reduce(0,{$0 + $1.value})
        case 2:
            return months[selectedIndex].dayStatistics.reduce(0,{$0 + $1.value})
        default:
            print("Error getting progress number")
            return 0
        }
    }
    
    func getTotal(tab: Int) -> Int{
        switch tab {
        case 0:
            let content = days.reduce(0,{$0 + $1.hourStatistics.reduce(0,{$0 + $1.value})})
            return content
        case 1:
            let content = weeks.reduce(0,{$0 + $1.weekDayStatistics.reduce(0,{$0 + $1.value})})
            return content
        case 2:
            let content = months.reduce(0,{$0 + $1.dayStatistics.reduce(0,{$0 + $1.value})})
            return content
        default:
            print("Error getting progress number")
            return 0
        }
    }
    
    func getName(tab: Int) -> String{
        switch tab {
        case 0:
            return days[selectedIndex].name + " total"
        case 1:
            return "Week total"
        case 2:
            return "Month total"
        default:
            print("Error getting name for statistics")
            return ""
        }
    }
    
    func slideToIndex(places:Int, tab: Int){
        switch tab {
        case 0:
            let items = days
            if (selectedIndex != 0 && places < 0) || (selectedIndex != (items.count-1) && places > 0){
                selectedIndex = selectedIndex + places
            }
            break
        case 1:
            let items = weeks
            if (selectedIndex != 0 && places < 0) || (selectedIndex != (items.count-1) && places > 0){
                selectedIndex = selectedIndex + places
            }
            break
        case 2:
            let items = months
            if (selectedIndex != 0 && places < 0) || (selectedIndex != (items.count-1) && places > 0){
                selectedIndex = selectedIndex + places
            }
            break
        default:
            print("Error moving through results")
            let items: [Int] = []
            if (selectedIndex != 0 && places < 0) || (selectedIndex != (items.count-1) && places > 0){
                selectedIndex = selectedIndex + places
            }
            break
        }
    }
    
    private func fetchStatsForWeeks(){
        self.output?.showLoading(message: "getting data...")
        StatsService().getStatsPerWeekAndMonth() { (succeeded, message, weeks, months) -> () in
            self.output?.hideLoading()
            if succeeded {
                self.weeks = weeks
                self.months = months
                
                // 2. fetch for days now
                self.fetchStatsForDays()
            }else{
                self.output?.showError(message: message)
            }
        }
    }
    
    private func fetchStatsForDays(){
        self.output?.showLoading(message: "getting data...")
        StatsService().getStatsPerDays() { (succeeded, message, days) -> () in
            self.output?.hideLoading()
            if succeeded {
                self.days = days
                self.output?.populateView()
            } else {
                self.output?.showError(message: message)
            }
        }
        
    }
    
}
