//
//  DayStatistics.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

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
}