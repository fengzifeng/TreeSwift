//
//  treeModel.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/11/3.
//  Copyright © 2023 feng. All rights reserved.
//

import Foundation
import KakaJSON

struct TreeModel:Convertible {
    var name: String = ""
    var children: Array = Array<TreeChildrenModel>()
    
    func kj_modelType(from jsonValue: Any?, _ property: Property) -> Convertible.Type? {
            switch property.name {
            case "children": return TreeChildrenModel.self  // 
            default: return nil
            }
        }
    
}

struct TreeChildrenModel:Convertible {
    var name: String = ""
    var id: Int = 0
    
}

