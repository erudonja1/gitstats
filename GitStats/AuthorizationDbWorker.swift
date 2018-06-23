//
//  AuthorizationDbWorker.swift
//  GitStats
//
//  Created by mac on 23/06/2016.
//  Copyright © 2016 Elvis Studio. All rights reserved.
//

import SwiftyJSON

class AuthorizationDbWorker{
    
    func setLoggedIn(json: JSON){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(json["id"].stringValue, forKey: "token_id")
        userDefaults.setValue(json["token"].stringValue, forKey: "token")
    }
    
    func setLoggedOut(){
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "token_id")
        userDefaults.removeObject(forKey: "token")
        userDefaults.removeObject(forKey: "repo_path")
    }
    
    func getToken() -> String? {
        let userDefaults = UserDefaults.standard
        if let valueThatExist = userDefaults.value(forKey: "token") as? String{
            return valueThatExist
        }
        return nil
    }
    
    func getTokenId() -> String? {
        let userDefaults = UserDefaults.standard
        if let valueThatExist = userDefaults.value(forKey: "token_id") as? String{
            return valueThatExist
        }
        return nil
    }
    
    func getRepoPath() -> String? {
        let userDefaults = UserDefaults.standard
        if let valueThatExist = userDefaults.value(forKey: "repo_path") as? String{
            return valueThatExist
        }
        return nil
    }
    
    func setRepoPath(url rpath: String){
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(rpath, forKey: "repo_path")
    }
    
}
