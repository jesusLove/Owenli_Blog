//
//  Observable.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/12.
//  Copyright © 2018 LQQ. All rights reserved.
//

import Foundation
import UIKit

// 定义通知名常量
// 使用常量作为通知名，不要使用字符串或数字
extension Notification.Name {
    static let networkConnection = Notification.Name(rawValue: "networkConnection")
    static let batteryStatus = Notification.Name(rawValue: "batteryStatus")
    static let locationChange = Notification.Name(rawValue: "locationChange")
}

// 定义网络状态常量
enum NetworkConnectionStatus: String {
    
    case connected
    case disconnected
    case connecting
    case disconnecting
    case error
}

// 定义UserInfo中的Key值
enum StatusKey: String {
    case networkStatusKey
}

// 协议定义l观察者的基本结构
// 观察者一些实体的集合，严格依赖其他实体状态
//
protocol ObserverProtocol {
    var statusValue: String { get set }
    var statusKey: String { get }
    var notificationOfInterest: Notification.Name { get }
    func subscribe() // 订阅
    func unsubscribe() //取消订阅
    func handleNotification()
}

// 此模版类抽象如何*订阅*和*接受*重要实体/资源的通知的所有必要细节。
// 此类提供了一个钩子方法（handleNotification()），
// 所有的子类可以通过此方法在接收到特定通知时进行各种需要的操作。
// 此类基为一个*抽象*类，并不会在编译时被检测，但这似乎是一个异常场景。

class Observer: ObserverProtocol {
    var statusValue: String // 与notificationOfInterest通知关联
    
    // 通知的 userInfo 中的 key 值，
    // 通过此 key 值读取到特定的状态值并存储到 statusValue 变量。
    var statusKey: String
    // 此类所注册的通知名。
    var notificationOfInterest: Notification.Name
    
    init(statusKey: StatusKey, notification: Notification.Name) {
        self.statusValue = "N/A"
        self.statusKey = statusKey.rawValue
        self.notificationOfInterest = notification
        
        subscribe()
    }
    // 向 NotificationCenter 注册 self(this) 来接收所有存储在 notificationOfInterest 中的通知。
    // 当接收到任意一个注册的通知时，会调用 receiveNotification(_:) 方法。
    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: notificationOfInterest, object: nil)
    }
    // 在任意一个 notificationOfInterest 所定义的通知接收到时调用。
    // 在此方法中可以根据所观察的重要资源的改变进行任意操作。
    // 此方法**必须有且仅有一个参数（NSNotification 实例）。**
    @objc func receiveNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo[statusKey] as? String {
            statusValue = status
            handleNotification()
            print("Notification \(notification.name) received; status: \(status)")
        }
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: notificationOfInterest, object: nil)
    }
    // **必须重写此方法；且必须继承此类**
    // 我使用了些"技巧"来让此类达到抽象类的形式，因此你可以在子类中做其他任何事情而不需要关心关于 NotificationCenter 的细节。
    func handleNotification() {
        fatalError("ERROR: You must override the [handleNotification] method")
    }
    
    deinit {
        print("Observer unsubscribing from notification")
        unsubscribe()
    }
}

// ===============================================具体观察者示例===============================================================
// 一个具体观察者的例子。
// 通常来说，会有一系列（许多？）的观察者都会监听一些单独且重要的资源发出的通知。
// 需要注意此类已经简化了实现，并且可以作为所有通知的 handler 的模板。

class NetworkConnectionHandler: Observer {
    var view: UIView
    init(view: UIView) {
        self.view = view
        // 你可以创建任意类型的构造器，只需要调用 super.init 并传入合法且可以配合 NotificationCenter 使用的通知。
        super.init(statusKey: .networkStatusKey, notification: .networkConnection)
    }
    // **必须重写此方法**
    // 此方法中可以加入任何处理通知的逻辑。
    override func handleNotification() {
        // 对不同到的状态进行响应
        switch statusValue {
        case NetworkConnectionStatus.connected.rawValue:
            view.backgroundColor = UIColor.green
        case NetworkConnectionStatus.connecting.rawValue:
            view.backgroundColor = UIColor.yellow
        case NetworkConnectionStatus.disconnecting.rawValue:
            view.backgroundColor = UIColor.blue
        case NetworkConnectionStatus.disconnected.rawValue:
            view.backgroundColor = UIColor.red
        default: break
        }
//        if statusValue == NetworkConnectionStatus.connected.rawValue {
//            view.backgroundColor = UIColor.green
//        } else {
//            view.backgroundColor = UIColor.red
//        }
    }
}
// ===============================================被观察者示例===============================================================
// 一个被观察者的模板。
// 通常被观察者都是一些重要资源，在其自身某些状态发生改变时会广播通知给所有订阅者。
protocol ObservedProtocol {
    var statusKey: StatusKey { get }
    var notification: Notification.Name { get }
    func notifyObservers(about changeTo: String) -> Void
}
// 在任意遵循 ObservedProtocol 示例的某些状态发生改变时，会通知*所有*已订阅的观察者。
// **向所有订阅者广播**
extension ObservedProtocol {
    func notifyObservers(about changeTo: String) -> Void {
        NotificationCenter.default.post(name: notification, object: self, userInfo: [statusKey.rawValue : changeTo])
    }
}


