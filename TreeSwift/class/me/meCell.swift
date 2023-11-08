//
//  meCell.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/11/2.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class meCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let titleLabel =  UILabel.init(frame: CGRect(x: 15, y: 0, width: 100, height: 40))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.gray
        return titleLabel
    }()
    
    lazy var contentLabel: UILabel = {
        let contentLabel =  UILabel.init(frame: CGRect(x: ScreenWidth - 200 - 15, y: 0, width: 200, height: 40))
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.gray
        contentLabel.textAlignment = NSTextAlignment.right
        return contentLabel
    }()
    
    lazy var goButton: UIButton = {
        let goButton = UIButton.init(frame: CGRectMake(ScreenWidth - 80, 0, 80, 40))
        goButton.setImage(UIImage(named: "accessery_back"), for: UIControl.State.normal)
        goButton.addTarget(self, action: #selector(clickGo), for: UIControl.Event.touchUpInside)
        goButton.isHidden = true
        return goButton
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(goButton)
    }
    
    func updateCell(title:String) {
        self.titleLabel.text = title
        goButton.isHidden = true
        if(title == "用户名") {
            contentLabel.text = userinfo?.name
        }else if(title == "邮箱") {
//            contentLabel.text = "mrjasonfeng@163.com"

        }else if(title == "ID") {
            let ID :Int = userinfo!.id
            contentLabel.text = String(ID)
        }else if(title == "我的收藏") {
            contentLabel.text = ""
            goButton.isHidden = false
        }else if(title == "退出登录") {
            contentLabel.text = ""
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickGo(){
        
    }
}
