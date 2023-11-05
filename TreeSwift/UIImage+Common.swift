//
//  UIImage+Common.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

extension UIImage {
    public class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        
        let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 1, left: 1, bottom: 1, right: 1)) ?? UIImage.init()
    }
}


