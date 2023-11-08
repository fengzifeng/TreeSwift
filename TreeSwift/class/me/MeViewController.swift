//
//  FFMeViewController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class MeViewController: BaseViewController {
    
    lazy var tableView = UITableView.init(frame: CGRect(x: 0, y: NavH, width: ScreenWidth, height: ScreenHeigth - NavH - BarH - TabDiff), style: UITableView.Style.plain)

    lazy var arrayData: [String] = Array()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true

        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: Notification.Name(rawValue: Notification_LoginSuccess), object: nil)
        
        if userinfo != nil {
            self.arrayData = ["ID","用户名","邮箱","我的收藏","退出登录"]
        }
        self.view.backgroundColor = RGB(r: 242, g: 242, b: 242)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createheadView()
        tableView.register(meCell.self, forCellReuseIdentifier: "meCell")
        tableView.backgroundColor = RGB(r: 242, g: 242, b: 242)
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let parentVc : BaseViewController = self.parent as! BaseViewController
        parentVc.myTitle = "个人主页"
    }
    
    @objc func loginSuccess (){
        let parentVc : BaseViewController = self.parent as! BaseViewController
        parentVc.myTitle = userinfo!.name
        self.arrayData = ["ID","用户名","邮箱","我的收藏","退出登录"]
        tableView.tableHeaderView = createheadView()
        self.tableView.reloadData()
    }

    func createheadView() -> UIView {
        let headView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 280))
        let upBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 110))
        upBgView.backgroundColor = HexColor(value: 0xaa2d1b)
        headView.addSubview(upBgView)
        if (userinfo == nil) {
            let label: UILabel = UILabel.init(frame: CGRect(x: 0, y: 65, width: ScreenWidth, height: 15))
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = NSTextAlignment.center
            upBgView.height = 225
            label.text = "登录3D社群，体验更多功能"
            upBgView.addSubview(label)
            
            let loginButton: UIButton = UIButton(frame: CGRect(x: (ScreenWidth - 102)/2.0, y: label.bottom + 25, width: 102, height: 38))
            loginButton.addTarget(self, action: #selector(clickLogin), for: UIControl.Event.touchUpInside)
            loginButton.setTitle("注册/登录", for: UIControl.State.normal)
            loginButton.layer.masksToBounds = true
            loginButton.layer.cornerRadius = 3
            loginButton.layer.borderColor = UIColor.white.cgColor
            loginButton.layer.borderWidth = 1
            upBgView.addSubview(loginButton)
        } else {
            upBgView.height = 200
            headView.height = 200

            let userImageView = UIImageView.init(frame: CGRect(x: (ScreenWidth - 100)/2.0, y: 30, width: 100, height: 100))
            userImageView.image = UIImage.init(named: "about_avatar")
            upBgView.addSubview(userImageView)
        }
        
        return headView
    }
    
    @objc func clickLogin () {
        
        let vc = loginViewController.init()
        vc.type = authType.loginType
        self.present(vc, animated: true)
        
    }
    
    
    
}

extension MeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = arrayData[indexPath.row]
        if (title == "退出登录") {
            userinfo = nil
            UserDefaults.standard.removeObject(forKey: UserDefaultKey_LoginUser)
            arrayData.removeAll()
            tableView.tableHeaderView = createheadView()
            tableView.reloadData()
            UserDefaults.standard.removeObject(forKey: UserDefaultKey_LoginCookies)
        } else if (title == "我的收藏") {
            let vc = CollectViewController.init()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: meCell = tableView.dequeueReusableCell(withIdentifier: "meCell", for: indexPath) as! meCell
        cell.updateCell(title: self.arrayData[indexPath.row])
        return cell
    }
    
}
