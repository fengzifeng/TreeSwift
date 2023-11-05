//
//  NSString+Common.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

extension String {
    func stringWidthWith(font: UIFont, height: CGFloat) -> CGFloat {
        if self.count == 0  {
            return 0
        }
        
        var size = CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        size = self.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraph], context: nil).size
        
        return size.width;
    }
    
    
    func stringHeightWith(font: UIFont, width: CGFloat) -> CGFloat {
        if self.count == 0  {
            return 0
        }
        
        var size = CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        size = self.boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraph], context: nil).size
        
        return size.height;
    }
}
