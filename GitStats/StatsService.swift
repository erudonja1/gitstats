//
//  StatsService.swift
//  GitStats
//
//  Created by mac on 22/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
import UIKit

class StatsService {
    
    static var days: [DayStatistics] = []
    static var weeks: [WeekStatistics] = []
    static var months: [MonthStatistics] = []
    
    class func getStatsPerWeekAndMonth(forView: UIView, completionHandler: (Bool, String) -> ()) {
        UIService.showLoading(forView, message: "getting data...")
        ConfigService.manager?.request(.GET, "https://api.github.com/repos/github/linguist/stats/commit_activity",
            headers: ConfigService.getAuthorizationTokenHeader(AuthorizationService.token),
            parameters: nil, encoding: .JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
                if error == nil && json != nil && json["message"].stringValue == "" {
                    days = []
                    weeks = []
                    months = []
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "dd/MM"
                    
                    for(index, weekElement) in json{
                        let week = WeekStatistics()
                        week.fromDate = NSDate(timeIntervalSince1970: Double(weekElement["week"].stringValue)!)
                        week.toDate = NSDate().addDaysToDate(week.fromDate, val: 7)
                        
                        if index == "0" { week.name = "This week"}
                        else {week.name = formatter.stringFromDate(week.fromDate) + " - " + formatter.stringFromDate(week.toDate)}
                        
                        for(indexDay, dayElement) in weekElement["days"]{
                            let day = StatisticUnit()
                            let dayDate = NSDate().addDaysToDate(week.fromDate, val: Int(indexDay)!)
                            day.key = NSDate().getDay(dayDate)
                            day.value = dayElement.intValue
                            week.weekDayStatistics.append(day)
                        }
                        weeks.append(week)
                    }
                    updateMonths()
                    weeks = weeks.reverse()
                    completionHandler(true, "")
                }
                else {
                    var message = "Something went wrong"
                    if response == nil { message = "No internet connection"}
                    if json["message"].stringValue != "" {message = json["message"].stringValue}
                    completionHandler(false, message)
                }
                UIService.hideLoading(forView)
            })
    }
    
    class func getStatsPerDays(forView: UIView, completionHandler: (Bool, String) -> ()) {
        UIService.showLoading(forView, message: "getting data...")
        ConfigService.manager?.request(.GET, "https://api.github.com/repos/github/linguist/stats/punch_card",
            headers: ConfigService.getAuthorizationTokenHeader(AuthorizationService.token),
            parameters: nil, encoding: .JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
                if error == nil && json != nil && json["message"].stringValue == "" {
                    var dayStats = DayStatistics()
                    dayStats.name = NSDate().getDayName(1)
                    for(index, element) in json{
                        let dayName = NSDate().getDayName(element[0].intValue + 1)
                        if dayStats.name != dayName || Int(index) == json.count{
                            days.append(dayStats)
                            dayStats = DayStatistics()
                            dayStats.name = dayName
                        }
                        let hourOfDay = StatisticUnit()
                        hourOfDay.key = String(element[1].intValue) + "h"
                        hourOfDay.value = element[2].intValue
                        dayStats.hourStatistics.append(hourOfDay)
                    }
                    days.append(dayStats) // last one that is not added because of exiting loop
                    completionHandler(true, "")
                }
                else {
                    var message = "Something went wrong"
                    if response == nil { message = "No internet connection"}
                    if json["message"].stringValue != "" {message = json["message"].stringValue}
                    completionHandler(false, message)
                }
                UIService.hideLoading(forView)
            })
    }
    
    class func getRepoInfo(repoPath: String, forView: UIView, completionHandler: (Bool, String) -> ()) {
        UIService.showLoading(forView, message: "checking repository...")
        ConfigService.manager?.request(.GET, "https://api.github.com/repos/\(repoPath)",
            headers: ConfigService.getAuthorizationTokenHeader(AuthorizationService.token),
            parameters: nil, encoding: .JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
                if error == nil && json != nil && json["message"].stringValue == "" {
                    //questionable is it private or not
                    completionHandler(true, "")
                }
                else {
                    var message = "Something went wrong"
                    if response == nil { message = "No internet connection"}
                    if json["message"].stringValue != "" {message = json["message"].stringValue}
                    completionHandler(false, message)
                }
                UIService.hideLoading(forView)
            })
    }
    
    private class func updateMonths(){
        let today = NSDate()
        for i in 0..<12 {
            let month = today.addMonthsToDate(today, val: -(i))
            let weeksOfMonth = weeks.filter({ today.monthsFrom($0.fromDate) == i || today.monthsFrom($0.toDate) == i })
            let monthStats = MonthStatistics()
            if i == 0 {monthStats.name = "This month"}
            else {monthStats.name = month.getMonthName(month)}
            for(index, _) in weeksOfMonth.enumerate(){
                monthStats.dayStatistics += weeksOfMonth[index].weekDayStatistics
                monthStats.date = weeksOfMonth[index].fromDate
            }
            months.append(monthStats)
        }
    }
    
}