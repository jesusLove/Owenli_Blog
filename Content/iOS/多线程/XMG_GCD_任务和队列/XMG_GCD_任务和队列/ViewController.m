//
//  ViewController.m
//  XMG_GCD_任务和队列
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test9];
}

// 判断下列情况是否会产生死锁
#warning 产生死锁
- (void)test1 {
    
    
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    // 产生死锁
//    dispatch_sync(mainQueue, ^{
//        NSLog(@"任务B");
//    });
    // 不会产生死锁
    dispatch_async(mainQueue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
    });
    NSLog(@"执行任务C - %@",[NSThread currentThread]);
}


- (void)test2 {
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"执行任务C - %@",[NSThread currentThread]);
    });
    NSLog(@"执行任务D - %@",[NSThread currentThread]);
    // 执行顺序：A， B， C， D
}

/**
 异步 + 手动串行
 */
- (void)test3 {
    
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行任务C - %@",[NSThread currentThread]);
    });
    NSLog(@"执行任务D - %@",[NSThread currentThread]);
    // 执行顺序： A D 后面执行B C
}

/**
 同步 + 并发
 */
- (void)test4 {
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"执行任务C - %@",[NSThread currentThread]);
    });
    NSLog(@"执行任务D - %@",[NSThread currentThread]);
}

/**
 异步 + 并发
 */
- (void)test5 {
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    // 并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"执行任务C - %@",[NSThread currentThread]);
    });
    NSLog(@"执行任务D - %@",[NSThread currentThread]);
}

- (void)test6 {
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_SERIAL);
    // 异步任务，开辟了新的线程
    dispatch_async(queue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            NSLog(@"执行任务C - %@",[NSThread currentThread]);
        });
    });
    NSLog(@"执行任务D - %@",[NSThread currentThread]);
}
#warning 产生死锁
- (void)test7 {
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_SERIAL);
    // 异步任务，开辟了新的线程
    dispatch_sync(queue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
        dispatch_sync(queue, ^{
            NSLog(@"执行任务C - %@",[NSThread currentThread]);
        });
    });
    NSLog(@"执行任务D - %@",[NSThread currentThread]);
}

#pragma mark - 使用sync往当前串行队列中添加任务会产生死锁。

- (void)test8 {
    // 地址相同
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 地址不同，即使名字相同地址也不同。
    dispatch_queue_t queue3 = dispatch_queue_create("com.lqq.queue3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue4 = dispatch_queue_create("com.lqq.queue3", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue5 = dispatch_queue_create("com.lqq.queue5", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"%p %p %p %p %p", queue1, queue2, queue3, queue4, queue5);
}

#pragma mark - performSelector:withObject:afterDelay:的本质是往Runloop中添加定时器，子线程默认没有启动Runloop
//erformSelector:withObject:afterDelay:的本质是往Runloop中添加定时器，
// 底层使用定时器，NSTimer需要添加到RunLoop中
// 子线程默认没有启动Runloop
- (void)test9 {
    NSLog(@"执行任务A - %@",[NSThread currentThread]);
    // 子线程
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"执行任务B - %@",[NSThread currentThread]);
        [self performSelector:@selector(printTest) withObject:nil afterDelay:3]; // 与RunLoop有关，需要定时器
        
        // 验证
        [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"123");
        }];
        // 子线程使用Timer，需要开启RunLoop
        // 开启RunLoop
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
//        [self performSelector:@selector(printTest1) withObject:nil]; //调用objc_msgSend()
    });
    // 主线程
//    [self performSelector:@selector(printTest) withObject:nil afterDelay:3];
    NSLog(@"执行任务C - %@",[NSThread currentThread]);
    // 打印结果：A，B，C

}
- (void)printTest {
    //在主线程可以使用，在子线程无法使用
    NSLog(@"执行任务D - %@",[NSThread currentThread]);
}
- (void)printTest1 {
    //在主线程可以使用，在子线程无法使用
    NSLog(@"执行任务E - %@",[NSThread currentThread]);
}

#pragma mark - 下面代码执行结果
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test10];
}
- (void)test10 {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        // 运行完，线程结束
        NSLog(@"1");
        // 保证在线程不销毁，开启RunLoop即可实现
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    [self performSelector:@selector(printTest10) onThread:thread withObject:nil waitUntilDone:YES];
}
- (void)printTest10 {
    NSLog(@"2");
}
// 输出 1，之后crash。原因：线程在打印完1,机已经销毁了

//------------


@end
