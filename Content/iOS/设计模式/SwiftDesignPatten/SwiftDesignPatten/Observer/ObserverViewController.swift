//
//  ObserverViewController.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/12.
//  Copyright © 2018 LQQ. All rights reserved.
//

import UIKit

class ObserverViewController: UIViewController, ObservedProtocol {
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    // Mock 一些负责观察网络状况的实体对象。
    var networkConnectionHandler1: NetworkConnectionHandler?
    var networkConnectionHandler2: NetworkConnectionHandler?
    
    let statusKey: StatusKey = StatusKey.networkStatusKey
    let notification: Notification.Name = .networkConnection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkConnectionHandler1 = NetworkConnectionHandler(view: topView)
        networkConnectionHandler2 = NetworkConnectionHandler(view: bottomView)
        
    }
    // 模拟检测网络状态
    // 连接和断开
    @IBAction func switchChange(_ sender: UISwitch) {
        if sender.isOn {
            notifyObservers(about: NetworkConnectionStatus.connected.rawValue)
        } else {
            notifyObservers(about: NetworkConnectionStatus.disconnected.rawValue)
        }
    }
}
