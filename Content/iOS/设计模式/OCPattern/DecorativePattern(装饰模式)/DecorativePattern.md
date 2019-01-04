# 装饰模式

> **装饰模式**：动态地给一个对象添加一些额外的职责，就扩展功能来说，装饰模式相比生成子类更为灵活。


# 何为装饰模式

标准装饰模式包含一个抽象`Component`父类，声明一些操作。抽象的`Component`类可以被细分为一个叫`Decorator`的抽象类。`Decorator`包含了另一个`Component`的引用。`ConcreteDecorator`为其他`Component`或`Decorator`定义了几个扩展行为，并且会在自己的操作中执行内嵌的`Component`操作。（PS: 读完这些很懵逼/(ㄒoㄒ)/~~）

![装饰模式类图](http://design-patterns.readthedocs.io/zh_CN/latest/_images/Decorator.jpg)


# 例子

在Objective-C中，为`UIImage`创建图像滤镜，这里用两种方式实现。

## 通过真正的子类实现

![类图]()

## 通过`Category`实现


# 参考文档

[装饰模式](http://design-patterns.readthedocs.io/zh_CN/latest/structural_patterns/decorator.html)