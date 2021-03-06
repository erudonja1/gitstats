//
//  AnalysisService.swift
//  GitStats
//
//  Created by mac on 16/05/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
class AnalysisWorker {
    
    func get(inputs: [StatisticUnit], tab: Int) -> String{
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
        let lowCommits = inputs.filter({ $0.value <= minBorderValue})
        let middleCommits = inputs.filter({ $0.value > minBorderValue && $0.value < maxBorderValue})
        let highCommits = inputs.filter({ $0.value >= maxBorderValue })
        
        let counterArray = [lowCommits.count, middleCommits.count, highCommits.count]
        
        //get average value
        let average = getAverage(inputs: inputs)
        resultString += "\r\n Average commits: \(average)"
        
        //get productivity type
        resultString += "\r\n Productivity: \(getProductivity(average: average, min:minBorderValue, max:maxBorderValue))"
       
        //get consistency of productivity
       resultString += "\r\n Consistency: \(getConsistency(counterArray: counterArray))"

        //get most productive
        resultString += "\r\n Best: \(getBest(inputs: inputs))"
        return resultString
    }
    
    private func getAverage(inputs: [StatisticUnit]) -> Double{
        let onlyValues = inputs.map({$0.value})
        let sum = onlyValues.reduce(0, +)
        let average: Double = Double(sum) / Double(inputs.count)
        return round(average)
    }
    
    private func getProductivity(average: Double, min:Int, max:Int) -> String{
        if average <= Double(min) {return "low"}
        if average > Double(min) && average < Double(max) {return "middle"}
        if average > Double(max) {return "high"}
        return ""
    }
    
    private func getConsistency(counterArray: [Int]) -> String{
        let maxElement = counterArray.max()!
        if maxElement == 0 {return "0%"}
        let counterArraySum = counterArray.reduce(0, +)
        return "\((maxElement * 100)/counterArraySum)%"
    }
    
    private func getBest(inputs: [StatisticUnit]) -> String{
        let onlyValues = inputs.map({$0.value})
        let max = onlyValues.max()
        if max == 0 {return "none"}
        let best = inputs.filter({$0.value == max}).first
        return "\(best!.key)"
    }
    
}
