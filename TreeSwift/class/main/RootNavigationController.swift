//
//  RootNavigationController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (viewController.isKind(of: BaseViewController.self)) {
            if (self.viewControllers.count > 0) {
                let vc = viewController as!BaseViewController
                if (viewController.responds(to: #selector(vc.clickBackItem))) {
                    vc.navigationBackItem(target: viewController, action: #selector(vc.clickBackItem))
                }
            }
        }
        super.pushViewController(viewController, animated: animated)
    }
}

extension RootNavigationController : UINavigationControllerDelegate, UIGestureRecognizerDelegate {
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1 {
            return false
            
        }
        
        let topVC : BaseViewController = self.topViewController as! BaseViewController
        if topVC.responds(to: #selector(topVC.enableScreenEdgePanGesture)) {
            return topVC.enableScreenEdgePanGesture()
        }
        return true
    }
}
