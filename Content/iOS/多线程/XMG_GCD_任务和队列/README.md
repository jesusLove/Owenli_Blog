# 任务 & 队列

* 同步 `dispath_sync(queue, ^{})`
* 异步 `dispath_async(queue, ^{})`

* 串行 `Serial Dispatch Queue`
* 并发 `Concurrent Dispacth Queue `

# 创建任务

## 创建同步任务

```objective-c
dispatch_sync(queue, ^{
    NSLog(@"执行任务B - %@",[NSThread currentThread]);
});
```
## 创建异步任务

```objective-c
dispatch_async(queue, ^{
    NSLog(@"执行任务B - %@",[NSThread currentThread]);
});
```


# 创建队列

## 创建串行

```Objective-c
dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_SERIAL);
```

## 创建并发队列

```Objective-c
dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_CONCURRENT);
```
# 主队列和全局队列

主队列（main queue）: 是串行队列，在主RunLoop中执行。
全局队列 (global queue)：是并发队列，系统提供了四种优先级：高、默认、低、后台。

```objective-c
dispatch_queue_t mainQueue = dispatch_get_main_queue();

dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
```

# 注意问题

## 死锁问题

使用sync往当前串行队列中添加任务会产生死锁。

## performSelector:withObject:afterDelay 不执行问题

* `performSelector:withObject:afterDelay:`的本质是往Runloop中添加定时器，子线程默认没有启动`Runloop`
* 底层使用定时器，NSTimer需要添加到RunLoop中。
* 子线程默认没有启动Runloop。

# Dispatch_after 

指定时间后执行处理，使用`dispatch_after`实现。

```objective-c
#pragma mark - # dispatch_after
- (void)test_dispatch_after {
    // 3秒后用dispatch_after函数将Block追加到主队列中。
    // 在RunLoop中，若每隔1/60秒执行循环一次，那么Block最快3秒后执行，最慢(3 + 1/60)秒后执行。若主队列处理大量任务时，时间会更长。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"至少等待3秒钟");
    });
}
```

`dispatch_time` 和 `dispatch_walltime`区别？

* `dispatch_time`：第一个参数指定时间的开始，第二个参数是时间间隔，`1ull * NSEC_PER_SEC`为1秒。通常用来指定相对时间。

* `dispatch_walltime`：用来指定绝对时间。例如：2019.1.1 12:12:12。使用`struct timespec`类型类获取`dispatch_time`类型的值。