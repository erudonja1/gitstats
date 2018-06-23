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


protocol AuthorizationProtocol: class {
    
    func userAuthorized(repoPath: String)
    func userNotAuthorized(message: String)
    
    func repoInfoFetched()
    func repoInfoNotFetched(message: String)
    
}



class AuthorizationInteractor: AuthorizationNetworkProtocol, StatsNetworkProtocol{
    
    weak var presenter: AuthorizationProtocol?
    
    let tokenAppName: String = "GitStats"
    let client_id: String = "5cda0213674dc771c2ea"
    let client_secret: String = "7ac33bcc93304dbff77ae3968b417c89e3c7346a"
   
    func isLoggedIn() -> Bool{
        let authWorker = AuthorizationDbWorker()
        if let _ = authWorker.getToken(), let _ = authWorker.getTokenId(), let _ = authWorker.getRepoPath() {
            return true
        }
        return false
    }
    
    func login(username: String, password: String, rpath: String) {
        
        // check authentication token is in cache
        if isLoggedIn() == false {
            let parameters: Parameters = ["scopes": ["public_repo"],"note": "\(tokenAppName)","client_id": "\(client_id)","client_secret": "\(client_secret)"]
            let method: HTTPMethod = .post
            let url: URLConvertible = "https://api.github.com/authorizations"
            let headers: HTTPHeaders = API.getAuthorizationHeader(username: username, password:password)
            let encoding: ParameterEncoding = JSONEncoding.default
            
            let authorizationNetworkWorker: AuthorizationNetworkWorker = AuthorizationNetworkWorker()
            authorizationNetworkWorker.parent = self as AuthorizationNetworkProtocol
            authorizationNetworkWorker.fetchToken(repoPath: rpath, url: url, method: method, parameters: parameters, headers: headers, encoding: encoding)
            
        }else{
            //call success
            self.presenter?.userAuthorized(repoPath: rpath)
        }
    }
    
    func getRepoInfo(rpath repoPath: String){
        
        let authorizationDb = AuthorizationDbWorker()
        let parameters: Parameters? = nil
        let method: HTTPMethod = .get
        let url: URLConvertible = "https://api.github.com/repos/\(repoPath)"
        let headers: HTTPHeaders = API.getAuthorizationTokenHeader(token: authorizationDb.getToken() ?? "")
        let encoding: ParameterEncoding = JSONEncoding.default
        
        
        let statsNetworkWorker: StatsNetworkWorker = StatsNetworkWorker()
        statsNetworkWorker.parent = self as StatsNetworkProtocol
        statsNetworkWorker.fetchRepoInfo(repoPath: repoPath, url: url, method: method, parameters: parameters, headers: headers, encoding: encoding)
        
    }
    
    func logout(){
        let authService = AuthorizationDbWorker()
        if let token = authService.getToken(), let tokenId = authService.getTokenId() {
            AuthorizationNetworkWorker().removeToken(token: token, tokenId: tokenId)
        }
    }
    
    
    // Method implementation for AuthorizationNetworkProtocol
    func loginRequestSucceeded(rPath: String, json: JSON){
        AuthorizationDbWorker().setLoggedIn(json: json)
        self.presenter?.userAuthorized(repoPath: rPath)
    }
    func loginRequestFailed(response: DataResponse<Any>, json: JSON){
        self.logout()
        let defaultMessage = self.createErrorMessage(response: response, json: json)
        self.presenter?.userNotAuthorized(message: defaultMessage)
    }
    
    // Method implementation for StatsNetworkProtocol
    func repoRequestSucceeded(rPath: String, json: JSON){
        AuthorizationDbWorker().setRepoPath(url: rPath)
        self.presenter?.repoInfoFetched()
    }
    func repoRequestFailed(response: DataResponse<Any>, json: JSON){
        self.logout()
        let defaultMessage = self.createErrorMessage(response: response, json: json)
        self.presenter?.repoInfoNotFetched(message: defaultMessage)
    }
    
    func weekStatsRequestSucceeded(json: JSON){}
    func weeksStatsRequestFailed(response: DataResponse<Any>, json: JSON){}
    func statsPerDaysRequestSucceeded(json: JSON){}
    func statsPerDaysRequestFailed(response: DataResponse<Any>, json: JSON){}
    
    
    private func createErrorMessage(response: DataResponse<Any>, json: JSON) -> String{
        var defaultMessage = "Something went wrong"
        
        // 1. no wi-fi
        if response.response == nil { defaultMessage = "No internet connection"}
        
        // 2. server error
        if json["message"].stringValue != "" { defaultMessage = json["message"].stringValue}
        
        return defaultMessage
    }
}
