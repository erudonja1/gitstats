//
//  DateExtension.swift
//  GitStats
//
//  Created by mac on 27/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation


extension Date {
    func yearsFrom(date:Date) -> Int{
        return NSCalendar.current.component(.year, from: date)
    }
    func monthsFrom(date:Date) -> Int{
        return NSCalendar.current.component(.month, from: date)
    }
    func weeksFrom(date:Date) -> Int{
        return NSCalendar.current.component(.weekOfYear, from: date)
    }
    func daysFrom(date:Date) -> Int{
        return NSCalendar.current.component(.day, from: date)
    }
    func hoursFrom(date:Date) -> Int{
        return NSCalendar.current.component(.hour, from: date)
    }
    func minutesFrom(date:Date) -> Int{
        return NSCalendar.current.component(.minute, from: date)
    }
    func secondsFrom(date:Date) -> Int{
        return Calendar.current.component(.second, from: date)
    }
    func offsetFrom(date:Date) -> String {
        if yearsFrom(date: date)   > 0 { return "\(yearsFrom(date: date))y"   }
        if monthsFrom(date: date)  > 0 { return "\(monthsFrom(date: date))M"  }
        if weeksFrom(date: date)   > 0 { return "\(weeksFrom(date: date))w"   }
        if daysFrom(date: date)    > 0 { return "\(daysFrom(date: date))d"    }
        if hoursFrom(date: date)   > 0 { return "\(hoursFrom(date: date))h"   }
        if minutesFrom(date: date) > 0 { return "\(minutesFrom(date: date))m" }
        if secondsFrom(date: date) > 0 { return "\(secondsFrom(date: date))s" }
        return ""
    }
    
    //Get day name from date
    func getDay(dayDate: Date) -> String{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.weekday, from: dayDate as Date)
        let weekDay = myComponents.weekday
        return getDayName(weekDay: weekDay!)
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
    func getMonth(dayDate: Date) -> Int{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let myComponents = myCalendar.components(.month, from: dayDate as Date)
        return myComponents.month!
    }
    func getMonthName(dayDate: Date) -> String{
        let monthNum = getMonth(dayDate: dayDate)
        switch monthNum {
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
    func addDaysToDate(date: Date, val: Int) -> Date{
        let newDate = Calendar.current.date(byAdding: .day, value: val, to: date)!
        return newDate
    }
    func addMonthsToDate(date: Date, val: Int) -> Date{
        let newDate = Calendar.current.date(byAdding: .month, value: val, to: date)!
        return newDate
    }
    
    func getReadableDate(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        return formatter.string(from: date as Date)
    }
    func getReadableDateMonth(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d MMMM", options: 0, locale: NSLocale(localeIdentifier: "en-GB") as Locale)
        return formatter.string(from: date as Date)
    }
    func getReadableDateDay(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: NSLocale(localeIdentifier: "en-GB") as Locale)
        return formatter.string(from: date as Date)
    }
    func getReadableDateYear(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: NSLocale(localeIdentifier: "en-GB") as Locale)
        return formatter.string(from: date as Date)
    }

}
