//
//  ArticleCell.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift
import Kingfisher

class ArticleCell: UITableViewCell {
    
    var currentModel :Article? = nil
    
    
    lazy var userImageView: UIImageView = {
        let userImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 10
        userImageView.image = UIImage(named: "article_avatar")
        return userImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel =  UILabel.init(frame: CGRect(x: userImageView.right + 10, y: 10, width: 200, height: 15))
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.textColor = UIColor.gray
        nameLabel.text = "测试"
        return nameLabel
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel.init(frame: CGRect(x: 10, y: userImageView.bottom + 10, width: ScreenWidth - 20, height: 20))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        titleLabel.text = "这是一条测试数据"
        return titleLabel
    }()
    
    
    lazy var timeLabel: UILabel = {
        let timeLabel =  UILabel.init(frame: CGRect(x: ScreenWidth - 200 - 10, y: 10, width: 200, height: 15))
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.textColor = UIColor.gray
        timeLabel.text = "今天"
        timeLabel.textAlignment = NSTextAlignment.right
        return timeLabel
    }()
    
    lazy var chapterLabel: UILabel = {
        let chapterLabel =  UILabel.init(frame: CGRect(x: 10, y: self.titleLabel.bottom + 10, width: 200, height: 15))
        chapterLabel.font = UIFont.systemFont(ofSize: 10)
        chapterLabel.textColor = UIColor.red
        chapterLabel.text = "测试资源"
        return chapterLabel
    }()
    
    lazy var voteImageView: UIButton = {
        let voteImageView = UIButton(frame: CGRect(x: ScreenWidth - 30, y: self.chapterLabel.top, width: 20, height: 20))
        voteImageView.setBackgroundImage(UIImage(named: "like_nor"), for: UIControl.State.normal)
        voteImageView.setBackgroundImage(UIImage(named: "like_press"), for: UIControl.State.selected)
        voteImageView.addTarget(self, action: #selector(click(button:)), for: UIControl.Event.touchUpInside)
        
        return voteImageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.chapterLabel)
        self.contentView.addSubview(self.userImageView)
        self.contentView.addSubview(self.voteImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateModel(model:Article) {
        currentModel = model
        self.titleLabel.text = model.title
        let date = Date.dateWithTimeStamp(timestamp: model.shareDate)
        let dateStr = date.dateStringWithTimelineDate()
        
        self.timeLabel.text =  dateStr
        self.nameLabel.text = model.name
        self.chapterLabel.text = model.chapterName
//        self.userImageView.kf.setImage(with: URL(string: ""))
        self.voteImageView.isSelected = model.collect

    }
                                
    @objc func click(button:UIButton) {
        if(userinfo == nil) {
            let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.nav?.view.makeToast("请先登录")
            return
        }
        let urlStr = "https://www.wanandroid.com/lg/collect/\(self.currentModel!.id)/json"
        let cookies:String = String(UserDefaults.standard.string(forKey: UserDefaultKey_LoginCookies)!)
        if (!button.isSelected) {
        }
        request(urlStr,method:.post,headers: ["cookies":cookies]).responseJSON { response in
            guard let dict =  response.result.value else {return}
            let jsons = JSON(dict)
            if (jsons["errorCode"] != 0)
            {
                print(jsons["errorMsg"])
            } else {
                button.isSelected = !button.isSelected
            }
        }
        
    }
}
