//
//  ConfigService.swift
//  GitStats
//
//  Created by mac on 24/03/16.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON
import SwiftyJSON

class ConfigService {
    
    // CUSTOM VARIABLES
    static let memoryCapacity = 100 * 1024 * 1024; // 100 MB
    static let diskCapacity = 100 * 1024 * 1024; // 100 MB
    static let cache = NSURLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
    static var manager: Manager?

    // CUSTOM FUNCTIONS
    // main function for configuring all tools that are used through application
    class func configureTools(){
        // set Alamofire configuration and caching as single
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders
        configuration.HTTPAdditionalHeaders = defaultHeaders
        configuration.requestCachePolicy = .UseProtocolCachePolicy
        configuration.URLCache = cache
        manager = Alamofire.Manager(configuration: configuration)
    }
    
    //Creating authorization header by username and password, for Alamofire request
    class func getAuthorizationHeader(username: String, password: String) -> [String:String]{
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        return headers
    }
    
    //Creating authorization header by token, for Alamofire request
    class func getAuthorizationTokenHeader(token: String) -> [String:String]{
        return ["Authorization": "token \(token)"]
    }
    
}