//
//  logincell.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/11/1.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class logincell: UITableViewCell {
    var title: String = ""
    var loginObject: UserInfo  = UserInfo()
    lazy var textField: UITextField = {
        let textField: UITextField = UITextField(frame: CGRect(x: 15, y: 10, width: ScreenWidth - 30, height: 40))
        let line: UILabel = UILabel.init(frame: CGRect(x: 15, y: 39, width: textField.width, height: 1))
        line.backgroundColor = UIColor.gray
//        textField.addSubview(line)
        
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.textField)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: UITextField.textDidChangeNotification, object: nil)

    }
    
    @objc func textFieldDidChange(not: NSNotification) {
        let textField1: UITextField =  not.object as! UITextField;
        if (textField1 != textField) {return}
        
        let str = textField1.text
        if (str != nil) {
            if(title == "用户名") {
                loginObject.name = str!
            } else if(title == "密码" || title == "密码(不少于6位)") {
                loginObject.password = str!
            }   else if(title == "确认密码") {
                loginObject.repassword = str!
            }
        }
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateModel(title:String) {
        self.title = title
        self.textField.placeholder = title
    }
}
