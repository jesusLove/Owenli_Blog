//
//  MementoViewController.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/12.
//  Copyright © 2018 LQQ. All rights reserved.
//

import UIKit

class MementoViewController: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // "保存用户" 按钮按下时调用此方法。
    // 以 "userKey" 作为 stateName 的值将 User 类实例的属性
    // 保存到 UserDefaults 中。
    @IBAction func saveUserTapped(_ sender: UIButton) {
        if firstNameTF.text != "" && lastNameTF.text != "" && ageTF.text != "" {
            let user = User(firstName: firstNameTF.text!, lastName: lastNameTF.text!, age: ageTF.text!, stateName: "userKey")
            user.show() // 格式化输出
        }
    }
    // 在"恢复用户"按钮按下时调用此方法。
    // 以 "userKey" 作为 stateName 的值将 User 类实例的属性
    // 从 UserDefaults 中读取出来。
    @IBAction func restoreUserTapped(_ sender: UIButton) {
        let user = User(stateName: "userKey")
        firstNameTF.text = user.firstName
        lastNameTF.text = user.lastName
        ageTF.text = user.age
        user.show()
    }
}
