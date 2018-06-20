//
//  Authorization.swift
//  GitStats
//
//  Created by mac on 22/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class AuthService {
    
    static let sharedInstance: AuthService = AuthService()

    var token: String = ""
    var token_id: String = ""
    var repo_path: String = ""
    let tokenAppName: String = "GitStats"
    let client_id: String = "5cda0213674dc771c2ea"
    let client_secret: String = "7ac33bcc93304dbff77ae3968b417c89e3c7346a"
    let userDefaults = UserDefaults.standard
    
    func isLoggedIn() -> Bool{
        if let t = userDefaults.value(forKey: "token") {  token = t as! String }
        if let tid = userDefaults.value(forKey: "token_id") { token_id = tid as! String }
        if let rpath = userDefaults.value(forKey: "repo_path") { repo_path = rpath as! String }
        return token_id != "" && token != "" && repo_path != ""
    }
    
    func getToken(username: String, password: String, rpath: String, completionHandler: @escaping (Bool, String) -> ()) {
        
        // check authentication token is in cache
        if isLoggedIn() == false {
            // if token does not exist, create new one and save it
            let parameters: Parameters = ["scopes": ["public_repo"],"note": "\(tokenAppName)","client_id": "\(client_id)","client_secret": "\(client_secret)"]
            let method: HTTPMethod = .post
            let url: URLConvertible = "https://api.github.com/authorizations"
            let headers: HTTPHeaders = API.getAuthorizationHeader(username: username, password:password)
            let encoding: ParameterEncoding = JSONEncoding.default
            
            API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
                let jsonResult = API.cachedResponse(response: response)
                let json = JSON(jsonResult!)
                let error = response.result.error
                    
                    //this condition is because github API returns ALWAYS json
                    if error == nil && json != JSON.null && json["message"].stringValue == "" {
                        self.token = json["token"].stringValue
                        self.token_id = json["id"].stringValue
                        self.userDefaults.setValue(json["id"].stringValue, forKey: "token_id")
                        self.userDefaults.setValue(json["token"].stringValue, forKey: "token")
                        
                        //handle success
                        completionHandler(true, "")
                    }
                    else {
                        // handle Error
                        self.clearToken()
                        let defaultMessage = self.createErrorMessage(response: response, json: json)
                        completionHandler(false, defaultMessage)
                    }
                })
        }else{
            // handle success
            completionHandler(true, "")
        }
    }
    
    func getRepoInfo(rpath: String, completionHandler: @escaping (Bool, String) -> ()){
    
        //check repository info
        StatsService().getRepoInfo(repoPath: rpath, completionHandler: { (succeeded, msg) -> () in
            if succeeded {
                AuthService.sharedInstance.repo_path = rpath
                self.userDefaults.setValue(rpath, forKey: "repo_path")
                completionHandler(true, "")
                return
            }
            
            // handle Error
            self.clearToken()
            completionHandler(false, msg)
        })
    }
    
    
    private func createErrorMessage(response: DataResponse<Any>, json: JSON) -> String{
        var defaultMessage = "Something went wrong"
        
        // 1. no wi-fi
        if response.response == nil { defaultMessage = "No internet connection"}
        
        // 2. server error
        if json["message"].stringValue != "" { defaultMessage = json["message"].stringValue}
        
        return defaultMessage
    }
    
    func clearToken() {
        let parameters: Parameters? = nil
        let method: HTTPMethod = .delete
        let url: URLConvertible =  "https://api.github.com/authorizations/\(token_id)"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: token)
        let encoding: ParameterEncoding = JSONEncoding.default
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
                self.token=""
                self.token_id=""
                self.repo_path=""
                self.userDefaults.removeObject(forKey: "token_id")
                self.userDefaults.removeObject(forKey: "token")
                self.userDefaults.removeObject(forKey: "repo_path")
            })
    }
    
}
