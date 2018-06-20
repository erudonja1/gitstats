//
//  StatsService.swift
//  GitStats
//
//  Created by mac on 22/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class StatsService {
    
    func getStatsPerWeekAndMonth(completionHandler: @escaping (Bool, String, [WeekStatistics], [MonthStatistics]) -> ()) {
        
        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(AuthService.sharedInstance.repo_path)/stats/commit_activity"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: AuthService.sharedInstance.token)
        let encoding: ParameterEncoding = JSONEncoding.default
        
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                    var weeks = WeekStatistics.mapWeeks(json: json)
                    let months = MonthStatistics.mapMonths(weeks: weeks)
                    weeks = weeks.reversed()
                    completionHandler(true, "", weeks, months)
                }
                else {
                    let message = self.createErrorMessage(response: response, json: json)
                    completionHandler(false, message, [], [])
                }
            })
    }
    
    func getStatsPerDays(completionHandler: @escaping (Bool, String, [DayStatistics]) -> ()) {
        
        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(AuthService.sharedInstance.repo_path)/stats/punch_card"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: AuthService.sharedInstance.token)
        let encoding: ParameterEncoding = JSONEncoding.default
        
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response)in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                    let days = DayStatistics.mapDays(json: json)
                    completionHandler(true, "", days)
                }
                else {
                    let message = self.createErrorMessage(response: response, json: json)
                    completionHandler(false, message, [])
                }
            })
    }
    
    func getRepoInfo(repoPath: String, completionHandler: @escaping (Bool, String) -> ()) {
        
        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(repoPath)"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: AuthService.sharedInstance.token)
        let encoding: ParameterEncoding = JSONEncoding.default
        
        
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                    //questionable is it private or not
                    completionHandler(true, "")
                }
                else {
                    let message = self.createErrorMessage(response: response, json: json)
                    completionHandler(false, message)
                }
            })
    }
    
    private func createErrorMessage(response: DataResponse<Any>, json: JSON) -> String{
        var message = "Something went wrong"
        if response.response == nil { message = "No internet connection"}
        if json["message"].stringValue != "" {message = json["message"].stringValue}
        
        return message
    }
    
}
