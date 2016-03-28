//
//  Authorization.swift
//  GitStats
//
//  Created by mac on 22/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//
import Foundation
import UIKit

class AuthorizationService {
    
    static var token: String = ""
    static var token_id: String = ""
    static var repo_path: String = ""
    static let tokenAppName: String = "GitStats"
    static let client_id: String = "5cda0213674dc771c2ea"
    static let client_secret: String = "7ac33bcc93304dbff77ae3968b417c89e3c7346a"
    static let userDefaults = NSUserDefaults.standardUserDefaults()
    
    class func isCached() -> Bool{
        if let t = userDefaults.valueForKey("token") {  token = t as! String }
        if let tid = userDefaults.valueForKey("token_id") { token_id = tid as! String }
        if let rpath = userDefaults.valueForKey("repo_path") { repo_path = rpath as! String }
        return token_id != "" && token != "" && repo_path != ""
    }
    
    class func getToken(username: String, password: String, rpath: String, forView: UIView, completionHandler: (Bool, String) -> ()) {
        UIService.showLoading(forView, message: "signing...")
        // check authentication token is in cache
        if isCached() == false {
            // if token does not exist, create new one and save it
            ConfigService.manager?.request(.POST, "https://api.github.com/authorizations",
                headers: ConfigService.getAuthorizationHeader(username, password:password),
                parameters: [
                    "scopes": ["public_repo"],
                    "note": "\(tokenAppName)",
                    "client_id": "\(client_id)",
                    "client_secret": "\(client_secret)"
                ], encoding: .JSON)
                .responseSwiftyJSON({ (request, response, json, error) in
                    //this condition is because github API returns ALWAYS json
                    if error == nil && json != nil && json["message"].stringValue == "" {
                        token = json["token"].stringValue
                        token_id = json["id"].stringValue
                        userDefaults.setValue(json["id"].stringValue, forKey: "token_id")
                        userDefaults.setValue(json["token"].stringValue, forKey: "token")
                        //check repository info
                        StatsService.getRepoInfo(rpath, forView: forView, completionHandler: { (result, msg) -> () in
                            if result == true {
                                AuthorizationService.repo_path = rpath
                                userDefaults.setValue(rpath, forKey: "repo_path")
                                completionHandler(true, "")
                            }else{
                                clearToken()
                                completionHandler(false, msg)
                            }
                        })
                    }
                    else {
                        var message = "Something went wrong"
                        if response == nil { message = "No internet connection"}
                        if json["message"].stringValue != "" {message = json["message"].stringValue}
                        clearToken()
                        completionHandler(false, message)
                    }
                    UIService.hideLoading(forView)
                    
                })
        }else{
            UIService.hideLoading(forView)
            completionHandler(true, "")
        }
    }
    
    class func clearToken() {
        ConfigService.manager?.request(.DELETE, "https://api.github.com/authorizations/\(token_id)",
            headers: ConfigService.getAuthorizationTokenHeader(token),
            parameters: nil)
            .responseSwiftyJSON({ (request, response, json, error) in
                token=""
                token_id=""
                repo_path=""
                userDefaults.removeObjectForKey("token_id")
                userDefaults.removeObjectForKey("token")
                userDefaults.removeObjectForKey("repo_path")
                ConfigService.cache.removeAllCachedResponses()
            })
    }
    
    
}
