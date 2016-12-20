//
//  AnalysisServiceNew.swift
//  GitStats
//
//  Created by mac on 14/09/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
class AnalysisServiceNew {
    
    class func get(inputs: [StatisticUnit], tab: Int) -> String{
        let timeStart = NSDate().timeIntervalSince1970
        var resultString = ""
        let minBorderValue: Int, maxBorderValue: Int
        switch tab {
        case 0:
            minBorderValue = 1
            maxBorderValue = 5
            break
        case 1:
            minBorderValue = 5
            maxBorderValue = 10
            break
        case 2:
            minBorderValue = 10
            maxBorderValue = 20
            break
        default:
            minBorderValue = 0
            maxBorderValue = 1
        }
        
        //setting intro
        resultString += "\r\n These are statistics for commits analyzed by: \r\n commit zones between \(minBorderValue) and \(maxBorderValue) \r\n"
        
        //sorting commits per value
        var lowCommits:[StatisticUnit] = []
        for item in inputs {
            if item.value <= minBorderValue {lowCommits.append(item)}
        }
        var middleCommits:[StatisticUnit] = []
        for item in inputs {
            if item.value > minBorderValue && item.value < maxBorderValue {middleCommits.append(item)}
        }
        
        var highCommits:[StatisticUnit] = []
        for item in inputs {
            if item.value >= maxBorderValue {highCommits.append(item)}
        }
        
        let counterArray = [lowCommits.count, middleCommits.count, highCommits.count]
        
        //get average value
        let average = getAverage(inputs)
        resultString += "\r\n Average commits: \(average)"
        
        //get productivity type
        resultString += "\r\n Productivity: \(getProductivity(average, min:minBorderValue, max:maxBorderValue))"
        
        //get consistency of productivity
        resultString += "\r\n Consistency: \(getConsistency(counterArray))"
        
        //get most productive
        resultString += "\r\n Best: \(getBest(inputs))"
        
        let timeStop = NSDate().timeIntervalSince1970
        print(timeStop - timeStart)
        return resultString
    }
    
    
    //static function for Average
    class func getAverage(inputs: [StatisticUnit]) -> Double{
        var onlyValues: [Int] = []
        for item in inputs {
            onlyValues.append(item.value)
        }
        
        var sum = 0
        for item in onlyValues {
            sum = sum + item
        }
        
        let average: Double = Double(sum) / Double(inputs.count)
        return round(average)
    }
    
    //static function for Productivity
    class func getProductivity(average: Double, min:Int, max:Int) -> String{
        if average <= Double(min) {return "low"}
        if average > Double(min) && average < Double(max) {return "middle"}
        if average > Double(max) {return "high"}
        return ""
    }
    
    //static function for Consistency
    class func getConsistency(counterArray: [Int]) -> String{
        var maxElement = 0
        for item in counterArray {
            if item>maxElement {
                maxElement = item
            }
        }
        if maxElement == 0 {return "0%"}
        
        var counterArraySum = 0
        for item in counterArray {
            counterArraySum = counterArraySum + item
        }
        
        return "\((maxElement * 100)/counterArraySum)%"
    }
    
    //static function for Best result
    class func getBest(inputs: [StatisticUnit]) -> String{
        
        var onlyValues: [Int] = []
        for item in inputs {
            onlyValues.append(item.value)
        }
        
        var maxElement = 0
        for item in onlyValues {
            if item>maxElement {
                maxElement = item
            }
        }
        
        if maxElement == 0 {return "none"}
        var best:[StatisticUnit] = []
        for item in inputs {
            if item.value  == maxElement {best.append(item)}
        }
        
        return "\(best[0].key)"
    }
    
}