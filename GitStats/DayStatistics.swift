//
//  DayStatistics.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import SwiftyJSON
import Foundation

class DayStatistics{
    var name: String
    var date: NSDate
    var hourStatistics:[StatisticUnit]
    
    init(){
        self.name = ""
        self.date = NSDate()
        self.hourStatistics = [StatisticUnit]()
    }
    
    class func mapDays(json: JSON) -> [DayStatistics]{
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
