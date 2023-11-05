//
//  ArticleModel.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import KakaJSON

struct Article :Convertible {
    let title:String = ""
    let name:String = ""
    let shareDate:Double = 0
    let chapterName:String = ""
    let vote:Bool = false
    let link:String = ""
    let collect = false
    let id = 0
    
    
    
    func kj_modelKey(from property: KakaJSON.Property) ->  KakaJSON.ModelPropertyKey {
        if (property.name == "name"){
            return "shareUser"
        } else {
            return property.name
            
        }
//        switch property.name {
//        case "name":
//            return "shareUser"
//        default: break
//        }
    }

}
