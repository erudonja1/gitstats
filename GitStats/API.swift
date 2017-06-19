//
//  API.swift
//  GitStats
//
//  Created by mac on 13/06/17.
//  Copyright © 2017 Elvis Studio. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON

class API {
    
    // CUSTOM VARIABLES
    static let memoryCapacity = 500 * 1024 * 1024; // 500 MB
    static let diskCapacity = 500 * 1024 * 1024; // 500 MB
    static let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
    static var manager: SessionManager?
    
    // CUSTOM FUNCTIONS
    // main function for configuring all tools that are used through application
    class func configureTools(){
        // set Alamofire configuration and caching as single
        let configuration = URLSessionConfiguration.default
        let defaultHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders
        configuration.httpAdditionalHeaders = defaultHeaders
      //  configuration.requestCachePolicy = .reload
       // configuration.urlCache = cache
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    //Creating authorization header by username and password, for Alamofire request
    class func getAuthorizationHeader(username: String, password: String) -> HTTPHeaders{
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        return headers
    }
    
    //Creating authorization header by token, for Alamofire request
    class func getAuthorizationTokenHeader(token: String) -> [String:String]{
        return ["Authorization": "token \(token)"]
    }

    
    class func cachedResponse(response: DataResponse<Any>) -> AnyObject?{
        switch response.result.isSuccess {
        case true:
            setResponseToCache(request: response.request! as NSURLRequest, response: response.response!, data: response.data! as NSData)
            return response.result.value as AnyObject?
        case false:
            return getResponseFromCache(request: response.request! as NSURLRequest)
        }
    }
    
    class func setResponseToCache(request: NSURLRequest, response: URLResponse, data: NSData){
        let newResponse = HTTPURLResponse(url: (request.url)!, statusCode: 200, httpVersion: "1.1", headerFields: ["Cache-Control":"public", "Content-type":"application/json"])
        let cachedURLResponse = CachedURLResponse(response: newResponse!, data: data as Data, userInfo: nil, storagePolicy: .allowed)
        cache.storeCachedResponse(cachedURLResponse, for: request as URLRequest)
    }
    
    class func getResponseFromCache(request:NSURLRequest) -> AnyObject?{
        do{
            let resp = cache.cachedResponse(for: request as URLRequest)
            if resp != nil && resp?.data != nil {
                let jsn = try JSONSerialization.jsonObject(with: resp!.data, options:[])
                return jsn as AnyObject?
            }
            else {
                return nil
            }
        }catch {
            return nil
        }
    }
    
    /*
    func read <T> (_ type:T.Type, url: String, finished:@escaping (Array<T>)->()) where T:Mappable,T:Meta{
        API.manager!.request(url).responseJSON(completionHandler: {(response) in
            var items: Array<T> = Array<T>()
            let result = API.cachedResponse(response)
            if result != nil {
                items = Mapper<T>().mapArray(JSONObject: result)!
            }
            finished(items)
        })
    }
    
    
    func readJson <T> (_ type:T.Type,finished:@escaping (Array<T>)->()) where T:Mappable,T:Meta{
        API.manager!.request(type.url()).responseJSON(completionHandler: {(response) in
            var items = Array<T>()
            if response.result.isSuccess {
                let itemResults = JSON(response.data!)
                for (_,el) in itemResults {
                    let obj: T = Mapper<T>().map(JSONObject: el.rawValue)!
                    items.append(obj)
                }
            }else{
                print("")
            }
            finished(items)
        })
    }*/
    
}
