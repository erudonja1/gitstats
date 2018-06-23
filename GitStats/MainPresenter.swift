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


class MainPresenter: MainPresenterProtocol {
    
    weak var output: MainViewProtocol?
    
    private let router: MainRouter = MainRouter()
    private let authorizationInteractor: AuthorizationInteractor = AuthorizationInteractor()
    private let mainInteractor: MainInteractor = MainInteractor()
    
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
        authorizationInteractor.logout()
        router.navigateToLogin(from: viewController)
    }
    
    func analyze(selectedIndex: Int?){
        self.output?.showLoading(message: "analyzing...")
        
        let selectedTabIndex = selectedIndex ?? 0
        let chartData = self.getDataChart(tab: selectedTabIndex)
        let analysisResult = AnalysisWorker().get(inputs: chartData, tab: selectedTabIndex)
        
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
    
    func getTitle(tab: Int) -> String{
        switch tab {
        case 0:
            return "Days statistics"
        case 1:
            return "Weekly statistics"
        case 2:
            return "Monthly statistics"
        default:
            print("Error getting title content")
            return ""
        }
    }
    
    func getSubTitle(tab: Int) -> String{
        switch tab {
        case 0:
            return "Commits code-frequency for each hour per day"
        case 1:
            return "Commits summary for week, per days"
        case 2:
            return "Commits summary for each day in month"
        default:
            print("Error getting subtitle content")
            return ""
        }
    }
    
    func getDescription(tab: Int) -> String{
        switch tab {
        case 0:
            return "Shows the hours that have most commits usually. Best part of this is that you could see in which days and when there are best productivity. It takes summary of commits for each day in week(generally), not last week commits. In other words, it shows code frequency per each day in week. Swipe left-right for changing day, or down to refresh the data(need Internet connection)."
        case 1:
            return "Shows the days that have most commits per weeks. Here you can see the history of code commits. In other words, it shows how much there where code commits in this week, week before etc. Swipe left-right for changing week, or down to refresh the data(need Internet connection)."
        case 2:
            return "Shows the days that have most commits per months. Here you can see the history of code commits. In other words, it shows how much there where code commits in this month, month before etc. Swipe left-right for changing month, or down to refresh the data(need Internet connection)."
        default:
            print("Error getting title content")
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
        self.output?.showLoading(message: "Getting data for months...")
        self.mainInteractor.presenter = self as MainPresenter
        self.mainInteractor.getStatsPerWeekAndMonth()
    }
    
    private func fetchStatsForDays(){
        self.output?.showLoading(message: "Getting data for days...")
        self.mainInteractor.presenter = self as MainPresenter
        self.mainInteractor.getStatsPerDays()
        
    }
    
    func statsForWeeksFetched(weeks: [WeekStatistics], months: [MonthStatistics]){
        self.output?.hideLoading()
        self.weeks = weeks
        self.months = months
        
        // 2. fetch for days now
        self.fetchStatsForDays()
    }
    
    func statsForDaysFetched(days: [DayStatistics]){
        self.output?.hideLoading()
        self.days = days
        self.output?.populateView()
    }
    
    func errorHappened(message: String) {
         self.output?.hideLoading()
        self.output?.showError(message: message)
    }
    
    
    
}
