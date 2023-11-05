//
//  BaseViewController.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    var _myTitle: String
    var myTitle : String {
        set {
            self.myNavigationItem.title = newValue;
        }
        get {
            return self.myNavigationItem.title ?? _myTitle
        }
    }
    
    lazy var navigationBar : FFNavigationBar = {
        let navigationBar : FFNavigationBar = FFNavigationBar.init()
        navigationBar.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: NavH - 0.5)
        navigationBar.barTintColor = UIColor.white
        navigationBar.isTranslucent = false
        
        let shadow = NSShadow.init()
        shadow.shadowColor = UIColor.clear
        let shadowImage = UIImage.imageWithColor(color: HexColor(value: 0xececec), size: CGSize.init(width: ScreenWidth, height: 0.5))
        navigationBar.shadowImage = shadowImage
//        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:RGB(r: 50, g: 55, b: 78),NSAttributedString.Key.shadow:shadow,NSAttributedString.Key.font:18]
        navigationBar.pushItem(self.myNavigationItem, animated: false)
        return navigationBar
    }()
    
    lazy var myNavigationItem : UINavigationItem = {
        let myNavigationItem : UINavigationItem = UINavigationItem.init(title: "")
        return myNavigationItem
    }()
    
    @objc func enableScreenEdgePanGesture() -> Bool {
        return true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        _myTitle = ""
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        _myTitle = ""
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.navigationBar)
    }
    
    
    func navigationBackItem(target: UIViewController,action: Selector)  {
        let button = UIButton.init(frame: CGRectMake(5, 0, 30, 44))
        button.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        button.setImage(UIImage.init(named: "reader_naviBack"), for: UIControl.State.normal)
        let item = UIBarButtonItem.init(customView: button)

        self.myNavigationItem.leftBarButtonItem = item
    }

    @objc func clickBackItem() {
        self.navigationController?.popViewController(animated: true)
    }
}
