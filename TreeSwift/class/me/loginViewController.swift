//
//  loginViewController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/11/1.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Toast_Swift

enum authType:Int {
    case reginType = 1,loginType
};

class loginViewController: BaseViewController {
    var type: authType = authType.reginType
    var loginObject:UserInfo = UserInfo()
    lazy var arrayData: [String] = Array()
    var loginButton: UIButton? = nil
    var switchButton: UIButton? = nil

    lazy var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeigth), style: UITableView.Style.plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(type == authType.reginType) {
            self.title = "注册"
            arrayData = ["用户名","密码(不少于6位)","确认密码"]
        } else if (type == authType.loginType) {
            self.title = "登录"
            arrayData = ["用户名","密码"]
        }
        
        self.navigationBar.isHidden = true

        self.view.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createheadView()
        tableView.tableFooterView = createFootView()

        tableView.register(logincell.self, forCellReuseIdentifier: "logincell")
        tableView.backgroundColor = UIColor.white
        view.addSubview(tableView)
    }
    
    func createheadView() -> UIView {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 150))
        let closeButton: UIButton = UIButton(frame: CGRect(x: 10, y: 40, width: 30, height: 30))
        closeButton.addTarget(self, action: #selector(closeLogin), for: UIControl.Event.touchUpInside)
        closeButton.setImage(UIImage(named: "login_close"), for: UIControl.State.normal)
        headView.addSubview(closeButton)
        return headView
    }
    
    func createFootView() -> UIView {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 102))
        let button: UIButton = UIButton(frame: CGRect(x: 19, y: 22, width: ScreenWidth - 38, height: 42))
        button.addTarget(self, action: #selector(login), for: UIControl.Event.touchUpInside)
        button.backgroundColor = HexColor(value: 0xaa2d1b)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        view.addSubview(button)
        loginButton = button
        
        let downButton: UIButton = UIButton(frame: CGRect(x: 0, y: button.bottom + 16, width: ScreenWidth, height: 30))
        downButton.addTarget(self, action: #selector(clickSwitch), for: UIControl.Event.touchUpInside)
        downButton.setTitleColor(HexColor(value: 0x6a6a6a), for: UIControl.State.normal)
        downButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(downButton)
        switchButton = downButton
        if (type == authType.loginType) {
            button.setTitle("登录", for: UIControl.State.normal)
            downButton.setTitle("没有账号？立即注册", for: UIControl.State.normal)
        } else if (type == authType.reginType) {
            button.setTitle("注册", for: UIControl.State.normal)
            downButton.setTitle("已有账号？立即登录", for: UIControl.State.normal)
        }
        
        return view
    }
    
    
    @objc func closeLogin (){
        self.dismiss(animated: true)
    }
    
    @objc func login (){
        var urlStr:String = "https://www.wanandroid.com/user/login"
        var params = ["username":loginObject.name,"password":loginObject.password]
        if (type == authType.reginType) {
            urlStr = "https://www.wanandroid.com/user/register"
            params = ["username":loginObject.name,"password":loginObject.password,"repassword":loginObject.repassword]
        }
        
        
        request(urlStr,method:.post,parameters: params).responseJSON { response in
            guard let dict =  response.result.value else {return}
            let jsons = JSON(dict)
            if (jsons["errorCode"] != 0)
            {
                print(jsons["errorMsg"])
            } else {
                guard let dict = jsons["data"].dictionaryObject else {return}
                userinfo = dict.kj.model(type: UserInfo.self) as? UserInfo
                let jsonStr = userinfo?.kj.JSONObject()
                var jsonDict: Dictionary = JSON(jsonStr as Any).rawValue as! Dictionary<String, Any>
                jsonDict.removeValue(forKey: "password")
                jsonDict.removeValue(forKey: "repassword")
                UserDefaults.standard.setValue(jsonDict, forKey: UserDefaultKey_LoginUser)
                NotificationCenter.default.post(name: Notification.Name(rawValue: Notification_LoginSuccess), object: nil)
                let headerFields = response.response?.allHeaderFields as! [String : String]
                let userCookie =  headerFields["Set-Cookie"]
                UserDefaults.standard.set(userCookie, forKey: UserDefaultKey_LoginCookies)
                self.dismiss(animated: true)
                
                let appdelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                if (self.type == authType.reginType) {
                    appdelegate.nav?.view.makeToast("注册成功")

                } else if (self.type == authType.loginType) {
                    appdelegate.nav?.view.makeToast("登录成功")
                }

            }
        }
            
    }
    
    @objc func clickSwitch (){
        if (type == authType.reginType) {
            type = authType.loginType
            loginButton?.setTitle("登录", for: UIControl.State.normal)
            switchButton?.setTitle("没有账号？立即注册", for: UIControl.State.normal)
            arrayData = ["用户名","密码"]

        } else if (type == authType.loginType) {
            type = authType.reginType
            loginButton?.setTitle("注册", for: UIControl.State.normal)
            switchButton?.setTitle("已有账号？立即登录", for: UIControl.State.normal)
            arrayData = ["用户名","密码(不少于6位)","确认密码"]

        }
        
        tableView.reloadData()
    }
}

extension loginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

extension loginViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: logincell = tableView.dequeueReusableCell(withIdentifier: "logincell", for: indexPath) as! logincell
        cell.loginObject = self.loginObject
        cell.updateModel(title: self.arrayData[indexPath.row])
        return cell
    }
    
}
