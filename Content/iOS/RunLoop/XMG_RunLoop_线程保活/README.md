#  线程保活
```
    self.innerThread = [[LEThread alloc] initWithBlock:^{
        // 添加一个NSPort防止NSRunLoop销毁
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (isKeepingRunLoop && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
    }];
```
