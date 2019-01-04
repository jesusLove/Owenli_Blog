# 任务 & 队列

* 同步 dispath_sync(queue, ^{})
* 异步 dispath_async(queue, ^{})

* 串行 Serial Dispath Queue
* 并发 Concurrent Dispath Queue 

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


# 注意问题

## 死锁问题

使用sync往当前串行队列中添加任务会产生死锁。

## performSelector:withObject:afterDelay 不执行问题

* `performSelector:withObject:afterDelay:`的本质是往Runloop中添加定时器，子线程默认没有启动`Runloop`
* 底层使用定时器，NSTimer需要添加到RunLoop中。
* 子线程默认没有启动Runloop。

