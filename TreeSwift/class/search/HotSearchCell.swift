//
//  HotSearchCell.swift
//  TreeSwift
//
//  Created by 冯子丰 on 2023/11/6.
//

import Foundation
import UIKit

class HotSearchCell: UITableViewCell {
    var isHot = false
    var hotArray :[Any] = Array()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init(frame: CGRect(x: 10, y: 10, width: ScreenWidth - 20, height: 20))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "搜索热词"
        return titleLabel
    }()
    
    lazy var downView: UIView = {
        let downView = UIView.init(frame: CGRect(x: 0, y: titleLabel.bottom, width: ScreenWidth, height: 0))
        return downView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(downView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatecell(hotArray:Array<Any>) {
        self.hotArray = hotArray
        if (isHot) {
            titleLabel.text = "搜索热词"
        } else {
            titleLabel.text = "历史搜索"
        }
        downView.removeAllSubviews()
        
        var top = 10.0
        var left = 10.0
        let buttonHeight = 30.0
        var index = 1

        for item in hotArray {
            let str: String = item as! String

            let button = UIButton.init()
            var length = str.stringWidthWith(font: UIFont.systemFont(ofSize: 12), height: 13) + 20
            length = min(length, ScreenWidth - 20)
            button.frame = CGRect(x: left, y: top, width: length, height: buttonHeight)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = buttonHeight/2.0
            button.backgroundColor = HexColor(value: 0xf2f3f5)
            button.setTitleColor(HexColor(value: 0x2D3035), for: UIControl.State.normal)
            button.setTitle(str, for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.tag = index
            button.addTarget(self, action: #selector(clickButton(button:)), for: UIControl.Event.touchUpInside)
            downView.addSubview(button)
            index = index + 1
            left = left + length + 5
            if (left + length + 10 > ScreenWidth && index-1<hotArray.count) {
                top = top + buttonHeight + 5.0
                left = 10.0
            }
        }
        
        downView.height = top + buttonHeight + 5.0
    }
    
    @objc func clickButton(button: UIButton)  {
        if((self.viewController()?.isKind(of: SearchViewController.self)) != nil){
            (self.viewController() as! SearchViewController).addSearchResultView(text:self.hotArray[button.tag - 1] as! String)
        }
        
    }
    
    class func cellHeight(hotArray:Array<Any>) -> Double {
        var top = 10.0
        var left = 10.0
        let buttonHeight = 30.0
        var index = 0

        for item in hotArray {
            let str: String = item as! String
            var length = str.stringWidthWith(font: UIFont.systemFont(ofSize: 12), height: 13) + 20
            length = min(length, ScreenWidth - 20)
            index+=1
            left = left + length + 5
            if (left + length + 10 > ScreenWidth && index<hotArray.count) {
                top = top + buttonHeight + 5.0
                left = 10.0
            }
        }
        
        return top + buttonHeight + 5.0 + 5 + 30
    }
    
}
