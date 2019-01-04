//
//  ShapeFactory.swift
//  SwiftDesignPatten
//
//  Created by lqq on 2018/12/11.
//  Copyright © 2018 LQQ. All rights reserved.
//

import UIKit

let defaultHeight = 200
let defaultWidth = 300
let defaultColor = UIColor.blue

// 用于在控制器内绘制形状的协议
protocol HelperViewFactoryProtocol {
    func configure() // 配置
    func position() //位置
    func display() //u绘制
    var height: Int { get }
    var view: UIView { get }
    var parentView: UIView { get }
}

// 定义一个正方形
fileprivate class Square: HelperViewFactoryProtocol {
    var height: Int
    
    var view: UIView
    
    var parentView: UIView
    
    init(height: Int = defaultHeight, parentView: UIView) {
        self.height = height
        self.parentView = parentView
        view = UIView()
    }
    
    func configure() {
        let frame = CGRect(x: 0, y: 0, width: height, height: height)
        view.frame = frame
        view.backgroundColor = defaultColor
    }
    
    func position() {
        view.center = parentView.center
    }
    
    func display() {
        configure()
        position()
        parentView.addSubview(view)
    }
}

// 圆形： 继承自Square
fileprivate class Circle: Square {
    override func configure() {
        super.configure()
        view.layer.cornerRadius = view.frame.height / 2
        view.layer.masksToBounds = true
    }
}
// 矩形
fileprivate class Rectangle: Square {
    var width: Int
    init(width: Int = defaultWidth, height: Int = defaultHeight, parentView: UIView) {
        self.width = width
        super.init(height: height, parentView: parentView)
    }
    override func configure() {
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        view.frame = frame
        view.backgroundColor = UIColor.blue
    }
}

// 创建工厂

enum Shapes {
    case square
    case circle
    case rectangle
}

class ShapeFactory {
    let parentView: UIView
    init(parentView: UIView) {
        self.parentView = parentView
    }
    func create(as shape: Shapes) -> HelperViewFactoryProtocol {
        switch shape {
        case .square:
            let square = Square(parentView: parentView)
            return square
        case .circle:
            let circle = Circle(parentView: parentView)
            return circle
        case .rectangle:
            let rectangle = Rectangle(parentView: parentView)
            return rectangle
        }
    }
}

// 公共的工厂方法来展示形状
func createShape(_ shape: Shapes, on view: UIView) {
    let shapeFactory = ShapeFactory(parentView: view)
    shapeFactory.create(as: shape).display()
}

func getShape(_ shape: Shapes, on view: UIView) -> HelperViewFactoryProtocol {
    let shapeFactory = ShapeFactory(parentView: view)
    return shapeFactory.create(as: shape)
}
