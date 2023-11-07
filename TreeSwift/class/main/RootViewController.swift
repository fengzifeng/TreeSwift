//
//  ViewController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class RootViewController: BaseViewController, FFBarViewDelegate {
    
    private let titleArray = ["test1","test2"]
    
    var currentViewController : BaseViewController?
    var navArray = [HomeController.init(), TreeViewController.init(), MeViewController.init()]
    lazy var searchButton:  UIButton = {
        let searchButton: UIButton = UIButton.init(frame: CGRect(x: ScreenWidth - 80, y: StateBarH, width: 80, height: 44))
        searchButton.setImage(UIImage(named: "search_icon"), for: UIControl.State.normal)
        searchButton.addTarget(self, action: #selector(clickSearch), for: UIControl.Event.touchUpInside)
        return searchButton
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.purple
        self.view.addSubview(barView)
        self.swithchTapIndex(index: 0)
        self.navigationBar.addSubview(searchButton)
    }
    
    lazy var barView: FFBarView = {
        let barView = FFBarView.init(frame: CGRect.init(x: 0, y: self.view.height - BarH - TabDiff, width: ScreenWidth, height: BarH + TabDiff))
        barView.delegate = self
//        barView.backgroundColor = UIColor.red
        
        return barView
    }()
    
    func swithchTapIndex(index: NSInteger) {
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()
        currentViewController = navArray[index]
        self.addChild(currentViewController!)
        self.view.insertSubview(currentViewController!.view, belowSubview: navigationBar)
        if(index == 2){
            self.searchButton.isHidden = true
        } else {
            self.searchButton.isHidden = false
        }
    }
    
    private lazy var tableView :UITableView = {
        let tabView = UITableView.init(frame: self.view.frame, style: UITableView.Style.plain)
        tabView.delegate = self
        tabView.dataSource = self
        tabView.register(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        return tabView
        
    }()
    
    @objc func clickSearch(){
        let vc = SearchViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension RootViewController : UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            self.present(YYProvider.customBouncesStyle(), animated: true, completion: nil)
//        default:
//            self.present(YYProvider.tabbarWithNavigationStyle(), animated: true, completion: nil)
//        }
//    }
}


