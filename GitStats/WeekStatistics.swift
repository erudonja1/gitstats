//
//  WeekStatistics.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

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
}
