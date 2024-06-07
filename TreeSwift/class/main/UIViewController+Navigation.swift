//
//  UIViewController+Navigation.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

extension UIViewController {
    func setNavigationTitleView(view : UIView) {
    
        if self.isKind(of: BaseViewController.self) {
            let vc : BaseViewController = self as! BaseViewController
            vc.myNavigationItem.titleView = view
        } else {
            self.navigationItem.titleView = view
            
        }
    }
}





