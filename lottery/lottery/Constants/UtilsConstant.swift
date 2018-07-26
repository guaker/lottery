//
//  UtilsConstant.swift
//  doctor
//
//  Created by chenzhen on 16/5/5.
//  Copyright © 2016年 chenzhen. All rights reserved.
//

/**
 *  工具
 */
import UIKit

//app版本号
let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

//系统版本号
let systemVersion = UIDevice.current.systemVersion

//设备model @"iPhone", @"iPod touch"
let deviceModel = UIDevice.current.model

let keyWindow = UIApplication.shared.keyWindow

let appDelegate = UIApplication.shared.delegate as! AppDelegate

//屏幕高度
let screenHeight: CGFloat = UIScreen.main.bounds.height

//屏幕宽度
let screenWidth: CGFloat = UIScreen.main.bounds.width

let isIPhoneX: Bool = screenHeight == 812.0

let navHeight: CGFloat = isIPhoneX ? 88 : 64

let tabbarHeight: CGFloat = isIPhoneX ? 83 : 49

let bottomHeight: CGFloat = isIPhoneX ? 34 : 0
