
***请查看原文： [从 Aspects 源码中我学到了什么？](https://lision.me/aspects/)** 

# AOP

AOP面向切面编程一种编程范式，解决OOP的延伸问题。

例如：用户页面统计通用库封装。

# Aspects

`Aspects`是使用OC编写的AOP库。

# 内部结构

Aspects 内部定义了两个协议：

1. `AspectToken` - 用于注销 Hook
2. `AspectInfo` - 嵌入 Hook 中的 Block 首位参数

此外 Aspects 内部还定义了 4 个类：

1. `AspectInfo` - 切面信息，遵循 `AspectInfo` 协议
2. `AspectIdentifier` - 切面 ID，应该遵循 `AspectToken` 协议（作者漏掉了，已提 PR）
3. `AspectsContainer` - 切面容器
4. `AspectTracker` - 切面跟踪器


以及一个结构体：

* `AspectBlockRef` - 即 `_AspectBlock`，充当内部 Block


如果你扒一遍源码，还会发现两个内部静态全局变量：

* `static NSMutableDictionary *swizzledClassesDict;`
* `static NSMutableSet *swizzledClasses;`



注意：

区分`.class`和`object_getClass`？
* .class当target是instance则返回Class，当target是Class返回自身。
* object_getClass返回isa指针。
  
Note: 动态创建一个 Class 的完整步骤也是我们应该注意的。

* objc_allocateClassPair
* class_addMethod
* class_addIvar
* objc_registerClassPair
