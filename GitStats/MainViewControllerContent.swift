//
//  MainViewControllerContent.swift
//  GitStats
//
//  Created by mac on 19/06/17.
//  Copyright © 2017 Elvis Studio. All rights reserved.
//

import Foundation

extension MainViewController{
    
    func getDataChart(tab: Int, index: Int) -> [StatisticUnit]{
        self.selectedIndex = index
        switch tab {
        case 0:
            return days[index].hourStatistics
        case 1:
            return weeks[index].weekDayStatistics
        case 2:
            for (ind, _)  in months[index].dayStatistics.enumerated() {
                months[index].dayStatistics[ind].key = Date().getReadableDateDay(date: months[index].dayStatistics[ind].date)
            }
            return months[index].dayStatistics
        default:
            print("Error getting data for chart view")
            return []
        }
    }
    
    func slide(places:Int, tab: Int){
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
    
    func getDate(tab: Int, index: Int) -> String{
        switch tab {
        case 0:
            return "" //NSDate().getReadableDateMonth(StatsService.days[index].date) because days are not currently taken
        case 1:
            if weeks.count > 0
            {
                return Date().getReadableDateMonth(date: weeks[index].fromDate as Date)
            }else {
                return ""
            }
        case 2:
            if months.count > 0
            {
                return  Date().getReadableDateYear(date: months[index].date as Date)
            }else {
                return ""
            }
        default:
            print("Error getting date readable name for statistics date")
            return ""
        }
    }
    func getProgress(tab: Int, index: Int) -> Int{
        switch tab {
        case 0:
            return days[index].hourStatistics.reduce(0,{$0 + $1.value})
        case 1:
            return weeks[index].weekDayStatistics.reduce(0,{$0 + $1.value})
        case 2:
            return months[index].dayStatistics.reduce(0,{$0 + $1.value})
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
    func getName(tab: Int, index: Int) -> String{
        switch tab {
        case 0:
            return days[index].name + " total"
        case 1:
            return "Week total"
        case 2:
            return "Month total"
        default:
            print("Error getting name for statistics")
            return ""
        }
    }
}
