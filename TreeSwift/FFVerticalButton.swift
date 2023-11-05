//
//  FFVerticalButton.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class FFVerticalButton: UIButton {

    open var _space: CGFloat
    var space : CGFloat {
        set {
            _space = newValue
            self .adjustButton(highlighted: self.isHighlighted)
        }
        get {
            return _space
        }
    }
    
    
    override init(frame: CGRect) {
        _space = 5
        super.init(frame: frame)
        
        self.adjustButton(highlighted: self.isHighlighted)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        let oldImage = self .image(for: state)
        super.setImage(image, for: state)

        if (oldImage == nil) || !__CGSizeEqualToSize(oldImage?.size ?? CGSize.init(width: 0, height: 0), image?.size ?? CGSize.init(width: 0, height: 0)) {
            self.adjustButton(highlighted: self.isHighlighted)
        }
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        self.adjustButton(highlighted: self.isHighlighted)
    }
    
    override var frame: CGRect {
        didSet {
            super.frame = frame
            self.adjustButton(highlighted: self.isHighlighted)
        }
    }
    
    
    func adjustButton(highlighted: Bool) {
        var text: String?
        var image: UIImage?
        
        if highlighted {
            text = self.title(for: UIControl.State.highlighted)
            image = self.image(for: UIControl.State.highlighted)
        } else if self.isSelected {
            text = self.title(for: UIControl.State.selected)
            image = self.image(for: UIControl.State.selected)
        } else {
            text = self.title(for: UIControl.State.normal)
            image = self.image(for: UIControl.State.normal)
        }
        
        self.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top;
        self.imageEdgeInsets = UIEdgeInsets.zero
        self.titleEdgeInsets = UIEdgeInsets.zero

        let btnWidth: CGFloat = self.bounds.size.width
        let btnHeight: CGFloat = self.bounds.size.height
        let imgHeight: CGFloat = image?.size.height ?? 0
        let imgCenterX: CGFloat = self.imageView?.center.x ?? 0
        let textHeight: CGFloat = self.titleLabel?.bounds.size.height ?? 0
        
        let textWidth: CGFloat = text?.stringWidthWith(font: self.titleLabel?.font ?? UIFont.systemFont(ofSize: 15), height: textHeight) ?? 0
        let textCenterX: CGFloat = textWidth/2.0 +  (self.titleLabel?.frame.origin.x ?? 0)
        let top = (btnHeight - (imgHeight + self.space + textHeight)) / 2.0;

        self.imageEdgeInsets = UIEdgeInsets.init(top: top, left: (btnWidth / 2.0 - imgCenterX), bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets.init(top: imgHeight + self.space + top, left: (btnWidth / 2 - textCenterX), bottom: 0, right: 0)
    }
    

}
