//
//  NSDateExtension.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation


extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
    
    //Get day name from date
    func getDay(dayDate: NSDate) -> String{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: dayDate)
        let weekDay = myComponents.weekday
        return getDayName(weekDay)
    }
    func getDayName(weekDay: Int) -> String{
        switch weekDay {
        case 1:
            return "Sun"
        case 2:
            return "Mon"
        case 3:
            return "Tue"
        case 4:
            return "Wed"
        case 5:
            return "Thu"
        case 6:
            return "Fri"
        case 7:
            return "Sat"
        default:
            print("Error fetching day names")
            return "Day"
        }
    }
    func getMonthName(dayDate: NSDate) -> String{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Month, fromDate: dayDate)
        let weekDay = myComponents.month
        switch weekDay {
        case 1:
            return "January"
        case 2:
            return "February"
        case 3:
            return "March"
        case 4:
            return "April"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            print("Error fetching months")
            return "Month"
        }
    }
    func addDaysToDate(date: NSDate, val: Int) -> NSDate{
        let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: val,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))!
        return newDate
    }
    func addMonthsToDate(date: NSDate, val: Int) -> NSDate{
        let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
            .Month,
            value: val,
            toDate: date,
            options: NSCalendarOptions(rawValue: 0))!
        return newDate
    }
    
    func getReadableDate(date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter.stringFromDate(date)
    }
    func getReadableDateMonth(date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("d MMMM", options: 0, locale: NSLocale(localeIdentifier: "en-GB"))
        return formatter.stringFromDate(date)
    }
    func getReadableDateYear(date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = NSDateFormatter.dateFormatFromTemplate("MMMM yyyy", options: 0, locale: NSLocale(localeIdentifier: "en-GB"))
        return formatter.stringFromDate(date)
    }
}