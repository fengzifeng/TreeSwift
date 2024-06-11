//
//  FFNavigationBar.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class FFNavigationBar: UINavigationBar {

    override func layoutSubviews() {
        super.layoutSubviews()

        
        if ShortSystemVersion >= CGFloat(11) {
            for view : UIView in self.subviews {
                if NSStringFromClass(type(of: view)).contains("Background") {
                    view.frame = self.bounds
                } else if NSStringFromClass(type(of: view)).contains("ContentView") {
                    var frame = view.frame
                    frame.origin.y = 20
                    if IsIphonex {
                        frame.origin.y = 44
                    }
                    frame.size.height = self.bounds.size.height - frame.origin.y
                    view.frame = frame
                }
            }
        }
    }

}
