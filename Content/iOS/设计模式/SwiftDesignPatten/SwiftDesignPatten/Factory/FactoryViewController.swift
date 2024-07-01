//
//  FactoryViewController.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/11.
//  Copyright © 2018 LQQ. All rights reserved.
//

import UIKit

class FactoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // 每点击一次都会绘制一个图形
    @IBAction func drawCircle(_ sender: UIButton) {
        createShape(.circle, on: view)
    }
    
    @IBAction func drawSquare(_ sender: UIButton) {
        createShape(.square, on: view)
    }
    @IBAction func drawRectangle(_ sender: UIButton) {
        let shapeFactory = getShape(.rectangle, on: view)
        shapeFactory.display()
    }
}
