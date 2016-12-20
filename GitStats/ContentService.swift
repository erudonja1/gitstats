//
//  ContentService.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation

class ContentService {
    
    static var selectedIndex: Int = 0
    
    class func getDataChart(tab: Int, index: Int) -> [StatisticUnit]{
        selectedIndex = index
        switch tab {
        case 0:
            return StatsService.days[index].hourStatistics
        case 1:
            return StatsService.weeks[index].weekDayStatistics
        case 2:
            for (ind, _)  in StatsService.months[index].dayStatistics.enumerate() {
                StatsService.months[index].dayStatistics[ind].key = NSDate().getReadableDateDay(StatsService.months[index].dayStatistics[ind].date)
            }
            return StatsService.months[index].dayStatistics
        default:
            print("Error getting data for chart view")
            return []
        }
    }
    
    class func slide(places:Int, tab: Int){
        var items = []
        switch tab {
        case 0:
            items = StatsService.days
        case 1:
            items = StatsService.weeks
        case 2:
            items = StatsService.months
        default:
            print("Error moving through results")
            items = []
        }
        if (selectedIndex != 0 && places < 0) || (selectedIndex != (items.count-1) && places > 0){
            selectedIndex = selectedIndex + places
        }
    }
    
    
    class func getTitleContent(tab: Int) -> String{
        switch tab {
        case 0:
            return "Days statistics"
        case 1:
            return "Weekly statistics"
        case 2:
            return "Monthly statistics"
        default:
            print("Error getting title content")
            return ""
        }
    }
    class func getSubTitleContent(tab: Int) -> String{
        switch tab {
        case 0:
            return "Commits code-frequency for each hour per day"
        case 1:
            return "Commits summary for week, per days"
        case 2:
            return "Commits summary for each day in month"
        default:
            print("Error getting subtitle content")
            return ""
        }
    }
    class func getDescriptionContent(tab: Int) -> String{
        switch tab {
        case 0:
            return "Shows the hours that have most commits usually. Best part of this is that you could see in which days and when there are best productivity. It takes summary of commits for each day in week(generally), not last week commits. In other words, it shows code frequency per each day in week. Swipe left-right for changing day, or down to refresh the data(need Internet connection)."
        case 1:
            return "Shows the days that have most commits per weeks. Here you can see the history of code commits. In other words, it shows how much there where code commits in this week, week before etc. Swipe left-right for changing week, or down to refresh the data(need Internet connection)."
        case 2:
            return "Shows the days that have most commits per months. Here you can see the history of code commits. In other words, it shows how much there where code commits in this month, month before etc. Swipe left-right for changing month, or down to refresh the data(need Internet connection)."
        default:
            print("Error getting title content")
            return ""
        }
    }
    
    class func getDateContent(tab: Int, index: Int) -> String{
        switch tab {
        case 0:
            return "" //NSDate().getReadableDateMonth(StatsService.days[index].date) because days are not currently taken
        case 1:
            if StatsService.weeks.count > 0
            {
                return NSDate().getReadableDateMonth(StatsService.weeks[index].fromDate)
            }else {
                return ""
            }
        case 2:
            if StatsService.months.count > 0
            {
                return  NSDate().getReadableDateYear(StatsService.months[index].date)
            }else {
                return ""
            }
        default:
            print("Error getting date readable name for statistics date")
            return ""
        }
    }
    class func getProgressContent(tab: Int, index: Int) -> Int{
        switch tab {
        case 0:
            return StatsService.days[index].hourStatistics.reduce(0,combine: {$0 + $1.value})
        case 1:
            return StatsService.weeks[index].weekDayStatistics.reduce(0,combine: {$0 + $1.value})
        case 2:
            return StatsService.months[index].dayStatistics.reduce(0,combine: {$0 + $1.value})
        default:
            print("Error getting progress number")
            return 0
        }
    }
    class func getTotalContent(tab: Int) -> Int{
        switch tab {
        case 0:
            let content = StatsService.days.reduce(0,combine: {$0 + $1.hourStatistics.reduce(0,combine: {$0 + $1.value})})
            return content
        case 1:
            let content = StatsService.weeks.reduce(0,combine: {$0 + $1.weekDayStatistics.reduce(0,combine: {$0 + $1.value})})
            print(StatsService.weeks)
            return content
        case 2:
            let content = StatsService.months.reduce(0,combine: {$0 + $1.dayStatistics.reduce(0,combine: {$0 + $1.value})})
            print(StatsService.months)
            return content
        default:
            print("Error getting progress number")
            return 0
        }
        
    }
    class func getNameContent(tab: Int, index: Int) -> String{
        switch tab {
        case 0:
            return StatsService.days[index].name + " total"
        case 1:
            return "Week total" //StatsService.weeks[index].name + " total"
        case 2:
            return "Month total" //StatsService.months[index].name + " total"
        default:
            print("Error getting name for statistics")
            return ""
        }
    }  
}