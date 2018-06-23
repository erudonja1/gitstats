//
//  AuthorizationNetworkWorker.swift
//  GitStats
//
//  Created by mac on 23/06/2016.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


protocol AuthorizationNetworkProtocol: class{
    func loginRequestSucceeded(rPath: String, json: JSON)
    func loginRequestFailed(response: DataResponse<Any>, json: JSON)
}

class AuthorizationNetworkWorker{
    
    weak var parent: AuthorizationNetworkProtocol?
    
    
    func fetchToken(repoPath: String, url: URLConvertible, method: HTTPMethod, parameters: Parameters, headers: HTTPHeaders, encoding: ParameterEncoding){
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
            let jsonResult = API.cachedResponse(response: response)
            let json = JSON(jsonResult!)
            let error = response.result.error
            
            //this condition is because github API returns ALWAYS json
            if error == nil && json != JSON.null && json["message"].stringValue == "" {
                self.parent?.loginRequestSucceeded(rPath: repoPath, json: json)
            } else {
                self.parent?.loginRequestFailed(response: response, json: json)
            }
        })
    }
    
    func removeToken(token: String, tokenId: String) {
            let parameters: Parameters? = nil
            let method: HTTPMethod = .delete
            let url: URLConvertible =  "https://api.github.com/authorizations/\(tokenId)"
            let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: token)
            let encoding: ParameterEncoding = JSONEncoding.default
            API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
                print("Logged out!")
            })
    }
}
