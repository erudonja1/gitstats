//
//  MonthStatistics.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation

class MonthStatistics{
    var name: String // this month will have name "THIS MONTH", but rest of them will have names like "fromDate + toDate"
    var date: NSDate
    var dayStatistics:[StatisticUnit]
    
    init(){
        self.name = ""
        self.date = NSDate()
        self.dayStatistics = [StatisticUnit]()
    }
    
    class func mapMonths(weeks: [WeekStatistics]) -> [MonthStatistics]{
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
}
