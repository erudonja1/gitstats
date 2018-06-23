//
//  WeekStatistics.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import SwiftyJSON
import Foundation

class WeekStatistics{
    var name: String // this week will have name "THIS WEEK", but rest of them will have names like "fromDate + toDate"
    var fromDate: NSDate
    var toDate: NSDate
    var weekDayStatistics:[StatisticUnit]
    
    init(){
        self.name = ""
        self.fromDate = NSDate()
        self.toDate = NSDate()
        self.weekDayStatistics = [StatisticUnit]()
    }
    
    class func mapWeeks(json: JSON) -> [WeekStatistics]{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        var weeks = [WeekStatistics]()
        for(index, weekElement) in json{
            let week = WeekStatistics()
            
            if let weekStartTimeInterval = Double(weekElement["week"].stringValue) {
                week.fromDate = NSDate(timeIntervalSince1970: weekStartTimeInterval)
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
        }
        return weeks
    }
}
