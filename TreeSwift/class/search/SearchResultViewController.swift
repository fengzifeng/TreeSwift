//
//  SearchResultViewController.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/6.
//

import Foundation
import UIKit

class SearchResultViewController: BaseViewController {
    
    var titleStr: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTitle = titleStr ?? ""
        
    }
}
