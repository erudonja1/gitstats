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

class AuthorizationService {
    
    static var token: String = ""
    static var token_id: String = ""
    static var repo_path: String = ""
    static let tokenAppName: String = "GitStats"
    static let client_id: String = "5cda0213674dc771c2ea"
    static let client_secret: String = "7ac33bcc93304dbff77ae3968b417c89e3c7346a"
    static let userDefaults = UserDefaults.standard
    
    class func isCached() -> Bool{
        if let t = userDefaults.value(forKey: "token") {  token = t as! String }
        if let tid = userDefaults.value(forKey: "token_id") { token_id = tid as! String }
        if let rpath = userDefaults.value(forKey: "repo_path") { repo_path = rpath as! String }
        return token_id != "" && token != "" && repo_path != ""
    }
    
    class func getToken(username: String, password: String, rpath: String, forView: UIView, completionHandler: @escaping (Bool, String) -> ()) {
        UIService.showLoading(forView: forView, message: "signing...")
        // check authentication token is in cache
        if isCached() == false {
            // if token does not exist, create new one and save it
            let parameters: Parameters = ["scopes": ["public_repo"],"note": "\(tokenAppName)","client_id": "\(client_id)","client_secret": "\(client_secret)"]
            let method: HTTPMethod = .post
            let url: URLConvertible = "https://api.github.com/authorizations"
            let headers: HTTPHeaders = API.getAuthorizationHeader(username: username, password:password)
            let encoding: ParameterEncoding = JSONEncoding.default
            
            API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response)in
                let jsonResult = API.cachedResponse(response: response)
                let json = JSON(jsonResult!)
                let error = response.result.error
                    
                    //this condition is because github API returns ALWAYS json
                    if error == nil && json != JSON.null && json["message"].stringValue == "" {
                        token = json["token"].stringValue
                        token_id = json["id"].stringValue
                        userDefaults.setValue(json["id"].stringValue, forKey: "token_id")
                        userDefaults.setValue(json["token"].stringValue, forKey: "token")
                        //check repository info
                        StatsService().getRepoInfo(repoPath: rpath, forView: forView, completionHandler: { (result, msg) -> () in
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
                        if response.response == nil { message = "No internet connection"}
                        if json["message"].stringValue != "" {
                            message = json["message"].stringValue
                        }
                        clearToken()
                        completionHandler(false, message)
                    }
                
                
                    UIService.hideLoading(forView: forView)
                    
                })
        }else{
            UIService.hideLoading(forView: forView)
            completionHandler(true, "")
        }
    }
    
    class func clearToken() {
        let parameters: Parameters? = nil
        let method: HTTPMethod = .delete
        let url: URLConvertible =  "https://api.github.com/authorizations/\(token_id)"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: token)
        let encoding: ParameterEncoding = JSONEncoding.default
        API.manager?.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: {(response) in
                token=""
                token_id=""
                repo_path=""
                userDefaults.removeObject(forKey: "token_id")
                userDefaults.removeObject(forKey: "token")
                userDefaults.removeObject(forKey: "repo_path")
            })
    }
    
}
