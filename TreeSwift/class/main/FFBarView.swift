//
//  FFBarView.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

let barHeight: CGFloat = 49
let btnCount = 3
let btnWidth = ScreenWidth/CGFloat(btnCount)

protocol FFBarViewDelegate: NSObjectProtocol {
    func swithchTapIndex(index: NSInteger)
}

class FFBarView: UIView {
    
    var btnArray = [FFVerticalButton]()
    weak var delegate: FFBarViewDelegate?
    var selectIndex = -1
    
    let titleArray = ["首页","体系","我"]
    let imageArray = ["首页-默认","发现-默认","我的-默认"]
    let imageSelectArray = ["首页-选中","发现-选中","我的-选中"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.createBarView()
        self.addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var line : UIView = {
        let line = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 0.5))
        line.backgroundColor = HexColor(value: 0xececec)
        return line
    }()
    
    func createBarView() {
        for i in 0...2 {
            let button: FFVerticalButton = FFVerticalButton.init(frame: CGRect.init(x: CGFloat(i)*btnWidth, y: 0, width: btnWidth, height: barHeight))
            button.tag = i + 1;
            button.addTarget(self, action: #selector(clickSwitch(button:)), for: UIControl.Event.touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            button.setTitleColor(HexColor(value: 0xC5C7D3), for: UIControl.State.normal)
            button.setTitleColor(HexColor(value: 0xFF5C5C), for: UIControl.State.selected)
            button.setImage(UIImage.init(named: imageArray[i]), for: UIControl.State.normal)
            button.setImage(UIImage.init(named: imageSelectArray[i]), for: UIControl.State.selected)
            button.setImage(UIImage.init(named: imageSelectArray[i]), for: UIControl.State.highlighted)
            button.setTitle(titleArray[i], for: UIControl.State.normal)
            
            if i == 0 {
                button.isSelected = true
                self.clickSwitch(button: button)
            }
            
            self.addSubview(button)
            btnArray.append(button)
        }
    }
    
    @objc func clickSwitch(button: UIButton) {
        if (button.tag - 1) != selectIndex {
            delegate?.swithchTapIndex(index: button.tag - 1)
            for item in btnArray {
                item.isSelected = button.tag == item.tag
            }
        }
        selectIndex = button.tag - 1
    }
    
    
    

}
