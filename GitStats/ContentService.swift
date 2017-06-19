//
//  ContentService.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation

class ContentService {
    
    func getTitle(tab: Int) -> String{
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
    func getSubTitle(tab: Int) -> String{
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
    func getDescription(tab: Int) -> String{
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

}
