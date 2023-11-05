//
//  userInfo.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/31.
//  Copyright © 2023 feng. All rights reserved.
//

import Foundation
import KakaJSON

class UserInfo: Convertible {
    
    var name: String = ""
    var password: String = ""
    var repassword: String = ""
    var id: Int = 0
    var coinCount: Int = 0

    
    func kj_modelKey(from property: KakaJSON.Property) ->  KakaJSON.ModelPropertyKey {
        if (property.name == "name"){
            return "username"
        } else {
            return property.name
            
        }
//        switch property.name {
//        case "name":
//            return "shareUser"
//        default: break
//        }
    }
    
    required init() {
        
    }
    class func loginUser() -> UserInfo? {
        if (userinfo == nil) {
            let dict = UserDefaults.standard.object(forKey: UserDefaultKey_LoginUser)
            if (dict != nil) {
                let userDict: Dictionary = dict as! Dictionary<String, Any>
                userinfo = userDict.kj.model(type: UserInfo.self) as? UserInfo
                
                if (userinfo != nil) {
                    return userinfo
                }
            }
            return nil
        } else {
            return userinfo
        }
        
    }
}
