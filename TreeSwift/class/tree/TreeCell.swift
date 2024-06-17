//
//  TreeCell.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/11/3.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import KakaJSON
import SwiftyJSON

class TreeCell: UITableViewCell {
    var currentModel: TreeModel? = nil
    //测试2
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init(frame: CGRect(x: 10, y: 10, width: ScreenWidth - 20, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "这是一条测试数据"
        return titleLabel
    }()
    
    lazy var downView: UIView = {
        let downView = UIView.init(frame: CGRect(x: 0, y: titleLabel.bottom, width: ScreenWidth, height: 0))
        return downView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.downView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateModel(model:TreeModel) {
        currentModel = model
        self.titleLabel.text = model.name
        downView.removeAllSubviews()
        
        var top = 10.0
        var left = 10.0
        let buttonHeight = 30.0
        var index = 1

        for item in model.children {
            let button = UIButton.init()
            var length = item.name.stringWidthWith(font: UIFont.systemFont(ofSize: 12), height: 13) + 10
            length = min(length, ScreenWidth - 20)
            button.frame = CGRect(x: left, y: top, width: length, height: buttonHeight)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 5
            button.backgroundColor = HexColor(value: 0xaa2d1b)
            button.setTitle(item.name, for: UIControl.State.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            button.tag = index
            button.addTarget(self, action: #selector(clickButton(button:)), for: UIControl.Event.touchUpInside)
            downView.addSubview(button)
            index = index + 1
            left = left + length + 5
            if (left + length + 10 > ScreenWidth && index-1<model.children.count) {
                top = top + buttonHeight + 5.0
                left = 10.0
            }
        }
        
        downView.height = top + buttonHeight + 5.0
    }
    
    class func cellHeight(model:TreeModel) -> Double {
        var top = 10.0
        var left = 10.0
        let buttonHeight = 30.0
        var index = 0

        for item in model.children {
            var length = item.name.stringWidthWith(font: UIFont.systemFont(ofSize: 12), height: 13) + 10
            length = min(length, ScreenWidth - 20)
            index+=1
            left = left + length + 5
            if (left + length + 10 > ScreenWidth && index<model.children.count) {
                top = top + buttonHeight + 5.0
                left = 10.0
            }
        }
        
        return top + buttonHeight + 5.0 + 5 + 30
        
    }
    
    @objc func clickButton(button: UIButton) {
        let index = button.tag
        let item = self.currentModel?.children[index - 1]
        let vc: ArticleListViewController = ArticleListViewController.init()
        vc.cid = item!.id
        vc.titleStr = item!.name
        (UIApplication.shared.delegate as!AppDelegate).nav?.pushViewController(vc, animated: true)
    }
             
}
