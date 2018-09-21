//
//  ViewController.m
//  XMG_GCD_队列组
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
// 队列组的使用方法
@interface ViewController ()
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) int moneyCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test3];
}
#pragma mark - 多线程组
// dispatch_group_notify
- (void)test {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务1 - %@", [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务2 - %@", [NSThread currentThread]);
        }
    });
    //--------------示例1-------------------
    // 写法一， 等上面的任务执行完成后，才会在主队列中执行任务3
//    dispatch_group_notify(group, queue, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            for (int i = 0; i < 5; i++) {
//                NSLog(@"任务3 - %@", [NSThread currentThread]);
//            }
//        });
//    });
    
    //写法二：直接在主队列中执行
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"任务3 - %@", [NSThread currentThread]);
//        }
//    });
    //--------------示例2-------------------
    // 如果有多个notify会怎么执行呢？
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务3 - %@", [NSThread currentThread]);
        }
    });
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务4 - %@", [NSThread currentThread]);
        }
    });
    // 任务3和任务4是交替执行的
}
// dispatch_group_wait
- (void)test1 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务1 - %@", [NSThread currentThread]);
        }
    });
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务2 - %@", [NSThread currentThread]);
        }
    });
    // 监控任务是否完成，当完成时会返回0，不完成一直等待。
    long result = dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    if (result == 0) {
        NSLog(@"全部任务执行完成");
    }
}
#warning 线程同步问题
#pragma mark - 多线程的安全隐患
/*
 资源共享问题
 经典问题：存取钱，买卖票问题。
 一份数据同时多个线程读写时，会出现该问题
 */
// 示例

- (void)test2 {
    self.count = 15;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self printTest2];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self printTest2];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self printTest2];
        }
    });
}
- (void)printTest2 {
    NSInteger oldCount = self.count;
    sleep(0.2);
    oldCount --;
    self.count = oldCount;
    NSLog(@"还剩%ld张票 - %@", (long)oldCount, [NSThread currentThread]);
}


// 示例：存取钱问题
- (void)test3 {
    self.moneyCount = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self saveMoney];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self takeMoney];
        }
    });
}
- (void)saveMoney {
    int oldCount = self.moneyCount;
    sleep(0.2);
    oldCount += 50;
    self.moneyCount = oldCount;
    NSLog(@"存50，还剩%d钱", self.moneyCount);
}

- (void)takeMoney {
    int oldCount = self.moneyCount;
    sleep(0.2);
    oldCount -= 20;
    self.moneyCount = oldCount;
    NSLog(@"取20，还剩%d钱", self.moneyCount);
}

// 解决方案
// 线程同步技术
// 同步技术的核心技术：加锁


@end
