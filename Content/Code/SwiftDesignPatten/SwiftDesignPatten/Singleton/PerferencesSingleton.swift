//
//  PerferencesSingleton.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/11.
//  Copyright © 2018 LQQ. All rights reserved.
//

import Foundation

// 定义一个用户偏好设置的类，存放相关的设置
// 提供一个单例方法

class UserPreferences {
    // 枚举
    enum Preferences {
        enum UserCredentials: String {
            case passwordVisiile
            case password
            case username
        }
        enum AppState: String {
            case appFirstRun
            case dateLastRun
            case currentVersion
        }
    }
    // 用类的初始化方法创建一个静态的，常量实例
    static let shared = UserPreferences()
    
    // 私有的，存放共享资源
    private let userPreferences: UserDefaults
    
    private init() {
        userPreferences = UserDefaults.standard
    }
    
    // 通用设置Bool值的方法
    func setBooleanForKey(_ boolean: Bool, key: String) {
        if key != "" {
            userPreferences.set(boolean, forKey: key)
        }
    }
    // 通用获取Bool值的方法
    func getBooleanForKey(_ key: String) -> Bool {
        if let isBooleanValue = userPreferences.value(forKey: key) as! Bool? {
            print("Key \(key) is \(isBooleanValue)")
            return true
        }
        else {
            print("Key \(key) is false")
            return false
        }
    }
    
    // 示例：设置密码可见
    // 更新状态
    func setPasswordVisibity(_ boolean: Bool) {
        setBooleanForKey(boolean, key: Preferences.UserCredentials.passwordVisiile.rawValue)
    }
    // 获取状态
    func isPasswordVisible() -> Bool {
        let isVisible = getBooleanForKey(Preferences.UserCredentials.passwordVisiile.rawValue)
        if isVisible {
            return true
        } else {
            return false
        }
    }
    // ....
}
