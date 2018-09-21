//
//  LEBase.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEBase.h"

@interface LEBase()
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) int moneyCount;
@end
@implementation LEBase

#pragma mark - 线程同步方案

// OSSpinLock


#warning 线程同步问题 ----------------------------------
#pragma mark - 多线程的安全隐患
/*
 资源共享问题
 经典问题：存取钱，买卖票问题。
 一份数据同时多个线程读写时，会出现该问题
 */
// 示例：买票

- (void)sellTest {
    self.count = 15;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __sellTicket];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __sellTicket];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __sellTicket];
        }
    });
}
- (void)__sellTicket {
    
    
    NSInteger oldCount = self.count;
    sleep(0.2);
    oldCount --;
    self.count = oldCount;
    NSLog(@"还剩%ld张票 - %@", (long)oldCount, [NSThread currentThread]);

}


// 示例：存取钱问题
- (void)moneyTest {
    self.moneyCount = 100;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __saveMoney];
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            [self __takeMoney];
        }
    });
}
- (void)__saveMoney {
    int oldCount = self.moneyCount;
    sleep(0.2);
    oldCount += 50;
    self.moneyCount = oldCount;
    NSLog(@"存50，还剩%d钱", self.moneyCount);
}

- (void)__takeMoney {
    int oldCount = self.moneyCount;
    sleep(0.2);
    oldCount -= 20;
    self.moneyCount = oldCount;
    NSLog(@"取20，还剩%d钱", self.moneyCount);
}
@end
