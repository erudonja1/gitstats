//
//  StatsService.swift
//  GitStats
//
//  Created by mac on 22/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class StatsService {
    
    func getStatsPerWeekAndMonth(forView: UIView, completionHandler: @escaping (Bool, String, [WeekStatistics], [MonthStatistics]) -> ()) {
        UIService.showLoading(forView: forView, message: "getting data...")

        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(AuthorizationService.repo_path)/stats/commit_activity"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: AuthorizationService.token)
        let encoding: ParameterEncoding = JSONEncoding.default
        
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                    var weeks = self.mapWeeks(json: json)
                    let months = self.mapMonths(weeks: weeks)
                    weeks = weeks.reversed()
                    completionHandler(true, "", weeks, months)
                }
                else {
                    var message = "Something went wrong"
                    if response.response == nil { message = "No internet connection"}
                    if json["message"].stringValue != "" {message = json["message"].stringValue}
                    completionHandler(false, message, [], [])
                }
                UIService.hideLoading(forView: forView)
            })
    }
    
    func getStatsPerDays(forView: UIView, completionHandler: @escaping (Bool, String, [DayStatistics]) -> ()) {
        UIService.showLoading(forView: forView, message: "getting data...")

        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(AuthorizationService.repo_path)/stats/punch_card"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: AuthorizationService.token)
        let encoding: ParameterEncoding = JSONEncoding.default
        
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response)in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                    let days = self.mapDays(json: json)
                    completionHandler(true, "", days)
                }
                else {
                    var message = "Something went wrong"
                    if response.response == nil { message = "No internet connection"}
                    if json["message"].stringValue != "" {message = json["message"].stringValue}
                    completionHandler(false, message, [])
                }
                UIService.hideLoading(forView: forView)
            })
    }
    
    func getRepoInfo(repoPath: String, forView: UIView, completionHandler: @escaping (Bool, String) -> ()) {
        
        UIService.showLoading(forView: forView, message: "checking repository...")
        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(repoPath)"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: AuthorizationService.token)
        let encoding: ParameterEncoding = JSONEncoding.default
        
        
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                    //questionable is it private or not
                    completionHandler(true, "")
                }
                else {
                    var message = "Something went wrong"
                    if response.response == nil { message = "No internet connection"}
                    if json["message"].stringValue != "" {message = json["message"].stringValue}
                    completionHandler(false, message)
                }
                UIService.hideLoading(forView: forView)
            })
    }
    
    private func mapWeeks(json: JSON) -> [WeekStatistics]{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        var weeks = [WeekStatistics]()
        for(index, weekElement) in json{
            let week = WeekStatistics()
            week.fromDate = NSDate(timeIntervalSince1970: Double(weekElement["week"].stringValue)!)
            week.toDate = Date().addDaysToDate(date: week.fromDate as Date, val: 7) as NSDate
            
            if index == "0" { week.name = "This week"}
            else {week.name = formatter.string(from: week.fromDate as Date) + " - " + formatter.string(from: week.toDate as Date)}
            
            for(indexDay, dayElement) in weekElement["days"]{
                var day = StatisticUnit()
                let index: Int = Int(indexDay)!
                day.date = Date().addDaysToDate(date: week.fromDate as Date, val: index)
                day.key = Date().getDay(dayDate: day.date as Date)
                day.value = dayElement.intValue
                week.weekDayStatistics.append(day)
            }
            weeks.append(week)
        }
        return weeks
    }
    
    private func mapMonths(weeks: [WeekStatistics]) -> [MonthStatistics]{
        let today = Date()
        var months = [MonthStatistics]()
        for i in 0..<12 {
            let month = today.addMonthsToDate(date: today, val: -(i))
            let monthNum = Date().getMonth(dayDate: month)
            let weeksOfMonth = weeks.filter({ monthNum == Date().getMonth(dayDate: $0.fromDate as Date)})
            
            let monthStats = MonthStatistics()
            if i == 0 {monthStats.name = "This month"}
            else {monthStats.name = month.getMonthName(dayDate: month)}
            for(index, _) in weeksOfMonth.enumerated(){
                let dayStatistics = weeksOfMonth[index].weekDayStatistics
                let date = weeksOfMonth[index].fromDate
                monthStats.dayStatistics += dayStatistics
                monthStats.date = date
            }
            months.append(monthStats)
        }
        return months
    }
    
    private func mapDays(json: JSON) -> [DayStatistics]{
        var days = [DayStatistics]()
        var dayStats = DayStatistics()
        dayStats.name = Date().getDayName(weekDay: 1)
        for(index, element) in json{
            let dayName = Date().getDayName(weekDay: element[0].intValue + 1)
            if dayStats.name != dayName || Int(index) == json.count{
                days.append(dayStats)
                dayStats = DayStatistics()
                dayStats.name = dayName
            }
            var hourOfDay = StatisticUnit()
            hourOfDay.key = String(element[1].intValue) //+ "h"
            hourOfDay.value = element[2].intValue
            dayStats.hourStatistics.append(hourOfDay)
        }
        days.append(dayStats) // last one that is not added because of exiting loop
        return days
    }
    
}
