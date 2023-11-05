//
//  FFConst.swift
//  swiftTest
//
//  Created by 冯子丰 on 2023/10/27.
//  Copyright © 2023 feng. All rights reserved.
//

import UIKit

var userinfo: UserInfo? = nil
let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeigth = UIScreen.main.bounds.size.height
let IsIphonex = checkIsIphoneX()
let TabDiff = (IsIphonex ? CGFloat(34) : 0)
let NavDiff = (IsIphonex ? CGFloat(24) : 0)
let StateBarH = UIApplication.shared.statusBarFrame.size.height
let NavH = StateBarH + 44
let BarH = CGFloat(49)
let ScaleX = (ScreenWidth / 375.0)
let ShortSystemVersion = CGFloat(Float(UIDevice.current.systemVersion) ?? 0)

let UserDefaultKey_LoginUser = "LoginUser"
let UserDefaultKey_LoginCookies = "LoginCookies"

let Notification_LoginSuccess = "LoginSuccess"


func SX(x : CGFloat) -> CGFloat {
    return x*ScaleX
}

func RGB(r: NSInteger, g: NSInteger, b:NSInteger) -> UIColor {
    return RGBA(r: r, g: g, b: b, a: 1)
}

func RGBA(r: NSInteger, g: NSInteger, b:NSInteger, a:CGFloat) -> UIColor {
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
}

func HexColor(value : UInt64 , alpha : CGFloat = 1) -> UIColor {
    let redValue = CGFloat((value & 0xFF0000) >> 16)/255.0
    let greenValue = CGFloat((value & 0xFF00) >> 8)/255.0
    let blueValue = CGFloat(value & 0xFF)/255.0
    return UIColor(red: redValue, green: greenValue, blue: blueValue, alpha: alpha)
}

func checkIsIphoneX() -> Bool {
    if #available(iOS 11.0, *) {
        let mainWindow = UIApplication.shared.delegate?.window
        if mainWindow??.safeAreaInsets.bottom ?? 0 > CGFloat(0) {
            return true
        }
    }
    
    return false
}


