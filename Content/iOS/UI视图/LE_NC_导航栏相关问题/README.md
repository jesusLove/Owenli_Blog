#  导航栏相关问题整理

# 自定义导航栏的方式

1. 重写NavigationController控制器管理器
    参考：[HBDNavigationBar](https://github.com/listenzz/HBDNavigationBar)
2. 隐藏导航栏或者设置透明，重新添加View或者NavigationBar
3. 使用Runtime中的Method Swizzle方式
    参考：
    [KMNavigationBarTransition](https://github.com/MoZhouqi/KMNavigationBarTransition/blob/master/README_CN.md)
    [YPNavigationBarTransition](https://github.com/yiplee/YPNavigationBarTransition)


# iOS11导航栏的变动
参考: [UIBarButtonItem在iOS11上的改变及应对方案](http://sketchk.xyz/2018/02/23/How-to-make-your-UIBarButtonItem-perfect-match-in-iOS/)

*  视图层级的变化
* 点击区域的变化
* 与屏幕间距的变化

## 视图层级的变化
 
 iOS11中，UINavigationBar开始支持Auto Layout。 对于UIBarButtonItem来说，所有的Item都被放在了Stack View中管理。当 Custom View 正确的实现了 sizeThatFits 或者 intrinsicContentSize 时，UI 的展现将不会出现问题。
 
 * 注意问题：
 
 ```
 UIView *view = [UIView new];
 if(@available(iOS 11, *)){
 view.translatesAutoresizingMaskIntoConstraints = NO;
 }
 UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
 self.navigationItem.rightBarButtonItem = item;
 ```
 
 ## 点击区域
 
 点击区域与Custom View的自身大小一致。解决方法参考上面的文章。
 
 ## 与屏幕间距的变化
 
 参考上面文章
 

# 其他问题

* 设置导航栏背景样式
  
```
    navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    navigationController?.navigationBar.shadowImage = UIImage() // shadowImage 就是那根 1px 的细线   
```

* 当需要改变导航栏背景色的透明度时，可以改变 setBackgroundImage:forBarMetrics: 中 image 的 alpha 值。

* 如果需要显示或隐藏导航栏，一般只需要在 viewWillAppear: 里设置，代码如下：

```
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hidden, animated: animated)
    }
```

在 iOS 8.2 或者之前的版本，如果导航栏的 translucent 值为 true 时，用 barTintColor 去设置导航栏的背景样式，然后改变 barTintColor 的颜色，那么当边缘左滑返回手势取消的时候导航栏的背景色会闪烁。

为了避免这种情况发生，推荐用 setBackgroundImage:forBarMetrics: 来改变导航栏的背景样式。
