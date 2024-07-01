//
//  SingletonViewController.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/11.
//  Copyright © 2018 LQQ. All rights reserved.
//

import UIKit

class SingletonViewController: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var passwordVisibleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 获取存储值
        if UserPreferences.shared.isPasswordVisible() {
            passwordVisibleSwitch.isOn = true
            passwordTF.isSecureTextEntry = false
        } else {
            passwordVisibleSwitch.isOn = false
            passwordTF.isSecureTextEntry = true
        }
    }
    
    @IBAction func passwordVisibleSwitched(_ sender: UISwitch) {
        if sender.isOn {
            passwordTF.isSecureTextEntry = false
            UserPreferences.shared.setPasswordVisibity(true) // 修改存储值
        } else {
            passwordTF.isSecureTextEntry = true
            UserPreferences.shared.setPasswordVisibity(false)
        }
    }
    
}
