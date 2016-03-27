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
}