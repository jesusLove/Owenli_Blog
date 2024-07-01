//
//  Memento.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/12.
//  Copyright © 2018 LQQ. All rights reserved.
//

import Foundation

// 由于"Cannot use mutating member on immutable value: ‘self’ is immutable"报错问题，
// 此协议定义为类协议，仅适用于引用类型。
protocol Memento: class {
    // 访问 UserDefaults 中 state 的key
    var stateName: String { get }
    
    // 存放遵循此协议的类当前状态下的所有属性名key 和 value
    var state: Dictionary<String, String> {get set}
    
    func save() // 以特定stateName为key将state属性存入到UserDefault中
    
    func restore() // 读出state
    
    func persist() // 自定义存储
    func recover() // 自定义获取
    
    func show() //格式化输出
}


extension Memento {
    // 存
    func save() {
        UserDefaults.standard.set(state, forKey: stateName)
    }
    // 取
    func restore() {
        if let dictionary = UserDefaults.standard.object(forKey: stateName) as! Dictionary<String, String>? {
            state = dictionary
        } else {
            state.removeAll()
        }
    }
    // 格式化输出
    func show() {
        var line = ""
        if state.count > 0 {
            for (key, value) in state {
                line += key + ": " + value + "\n"
            }
            print(line)
        } else {
            print("Empty entity.\n")
        }
    }
}

// 通过遵循 Memento 协议，任何类都可以方便地在整个应有运行期间
// 保存其完整状态，并能随后任意时间进行读取。
class User: Memento {
    // 必须遵循的属性
    let stateName: String
    
    var state: Dictionary<String, String>
    
    // 独有属性，用户保存系统用户账号
    var firstName: String
    var lastName: String
    var age: String
    
    // 此构造器可用于保存新用户到磁盘，或者更新一个现有的用户。
    // 持久化储存所用的 key 值为 stateName 属性。
    init(firstName: String, lastName: String, age: String, stateName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.stateName = stateName
        self.state = Dictionary<String, String>()
        persist()
    }
    // 此构造器可以从磁盘中读取出一个已存在的用户信息。
    // 读取所使用的 key 值为 stateName 属性。
    init(stateName: String) {
        self.stateName = stateName
        self.state = Dictionary<String, String>()
        self.firstName = ""
        self.lastName = ""
        self.age = ""
        
        recover()
    }
    // 持久化存储用户属性。
    // 此处很直观地将每个属性一对一地以"属性名-属性值"的形式存入字典中。
    func persist() {
        state["firstName"] = firstName
        state["lastName"] = lastName
        state["age"] = age

        save() // 保存
    }
    
    // 读取已存储的用户属性。
    // 从 UserDefaults 中读取了 state 字典后
    // 会简单地以属性名为 key 从字典中读取出属性值。
    func recover() {
        restore()
        if state.count > 0 {
            firstName = state["firstName"]!
            lastName = state["lastName"]!
            age = state["age"]!
        } else {
            self.firstName = ""
            self.lastName = ""
            self.age = ""
        }
    }
}
