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

protocol StatsNetworkProtocol: class {
    
    func repoRequestSucceeded(rPath: String, json: JSON)
    func repoRequestFailed(response: DataResponse<Any>, json: JSON)
    
    func weekStatsRequestSucceeded(json: JSON)
    func weeksStatsRequestFailed(response: DataResponse<Any>, json: JSON)
    
    func statsPerDaysRequestSucceeded(json: JSON)
    func statsPerDaysRequestFailed(response: DataResponse<Any>, json: JSON)
}


class StatsNetworkWorker {
    
    weak var parent: StatsNetworkProtocol?
    
    func fetchStatsPerWeekAndMonth(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding) {
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                self.parent?.weekStatsRequestSucceeded(json: json)
            } else {
                self.parent?.weeksStatsRequestFailed(response: response, json: json)
            }
        })
    }
    
    func fetchStatsPerDays(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding) {
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                self.parent?.statsPerDaysRequestSucceeded(json: json)
            } else {
                self.parent?.statsPerDaysRequestFailed(response: response, json: json)
            }
        })
    }
    
    func fetchRepoInfo(repoPath: String, url: URLConvertible, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders, encoding: ParameterEncoding) {
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            
            if json != JSON.null && json["message"].stringValue == "" {
                self.parent?.repoRequestSucceeded(rPath: repoPath, json: json)
            } else {
                self.parent?.repoRequestFailed(response: response, json: json)
            }
        })
    }
    
}
