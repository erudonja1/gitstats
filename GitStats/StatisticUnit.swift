//
//  HourStatistics.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation

struct StatisticUnit{
    var date: Date
    var key: String //name on X axis
    var value: Int //value on Y axis
    init(){
        self.key = ""
        self.value = 0
        self.date = Date()
    }
}
