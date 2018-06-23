//
//  MainInteractor.swift
//  GitStats
//
//  Created by mac on 23/06/2018.
//  Copyright © 2018 Elvis Studio. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

protocol MainPresenterProtocol: class {
    func statsForWeeksFetched(weeks: [WeekStatistics], months: [MonthStatistics])
    func statsForDaysFetched(days: [DayStatistics])
    func errorHappened(message: String)
}

class MainInteractor: StatsNetworkProtocol{
    
    weak var presenter: MainPresenterProtocol?
    
    func getStatsPerWeekAndMonth() {
        
        let authorizationDb = AuthorizationDbWorker()
        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(authorizationDb.getRepoPath() ?? "")/stats/commit_activity"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: authorizationDb.getToken() ?? "")
        let encoding: ParameterEncoding = JSONEncoding.default
        
        
        let statsNetworkWorker = StatsNetworkWorker()
        statsNetworkWorker.parent = self as StatsNetworkProtocol
        statsNetworkWorker.fetchStatsPerWeekAndMonth(url: url, method: method, parameters: parameters, headers: headers, encoding: encoding)
    }
    
    func getStatsPerDays() {
        
        let authorizationDb = AuthorizationDbWorker()
        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(authorizationDb.getRepoPath() ?? "")/stats/punch_card"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: authorizationDb.getToken() ?? "")
        let encoding: ParameterEncoding = JSONEncoding.default
        
        let statsNetworkWorker = StatsNetworkWorker()
        statsNetworkWorker.parent = self as StatsNetworkProtocol
        statsNetworkWorker.fetchStatsPerDays(url: url, method: method, parameters: parameters, headers: headers, encoding: encoding)
        
    }
    
    // Implementation Methods for StatsNetworkProtocol
    func weekStatsRequestSucceeded(json: JSON){
        var weeks = WeekStatistics.mapWeeks(json: json)
        let months = MonthStatistics.mapMonths(weeks: weeks)
        weeks = weeks.reversed()
        self.presenter?.statsForWeeksFetched(weeks: weeks, months: months)
    }
    func weeksStatsRequestFailed(response: DataResponse<Any>, json: JSON){
        let message = self.createErrorMessage(response: response, json: json)
        self.presenter?.errorHappened(message: message)
    }
    
    func statsPerDaysRequestSucceeded(json: JSON){
        let days = DayStatistics.mapDays(json: json)
        self.presenter?.statsForDaysFetched(days: days)
    }
    
    func statsPerDaysRequestFailed(response: DataResponse<Any>, json: JSON){
        let message = self.createErrorMessage(response: response, json: json)
         self.presenter?.errorHappened(message: message)
    }
    
    func repoRequestSucceeded(rPath: String, json: JSON){}
    func repoRequestFailed(response: DataResponse<Any>, json: JSON){}
    
    private func createErrorMessage(response: DataResponse<Any>, json: JSON) -> String{
        var defaultMessage = "Something went wrong"
        
        // 1. no wi-fi
        if response.response == nil { defaultMessage = "No internet connection"}
        
        // 2. server error
        if json["message"].stringValue != "" { defaultMessage = json["message"].stringValue}
        
        return defaultMessage
    }
    
}
