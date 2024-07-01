
# 监听相同的类

`UIViewController + Trace` 使用两种方式实现，埋点功能：一种`Swizzle Method`，另一种`Aspects`方式。

`TraceHandler`处理埋点逻辑。


```
+ (void)load {

[UIViewController aspect_hookSelector:@selector(viewDidAppear:)
                    withOptions:AspectPositionAfter
                    usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
                    NSString *className = NSStringFromClass([[aspectInfo instance] class]);
                    [TraceHandler traceStatusWithName:className];
                    }
                    error:NULL];

}

```
该方法功能是给`viewDidAppear`调用后挂载一个Block。当`viewDidAppear`处理完成后，执行block。

挂载方式

```
typedef NS_OPTIONS(NSUInteger, AspectOptions) {
AspectPositionAfter   = 0,            ///  Called after the original implementation (default)
AspectPositionInstead = 1,            /// Will replace the original implementation.
AspectPositionBefore  = 2,            /// Called before the original implementation.

AspectOptionAutomaticRemoval = 1 << 3 /// Will remove the hook after the first execution.
};

```

> 以上这两种方法，适用于监听相同的类。


# 监听不同的类

给`AppDelegate`添加分类。

通过配置监听`plist`，需要监听不同类，不同按钮，系统方法，及表单元点击事件

[iOS数据埋点统计方案选型(附Demo)：运行时Method Swizzling机制与AOP编程(面向切面编程)](https://juejin.im/post/5ae28f686fb9a07aaf34ee27)



