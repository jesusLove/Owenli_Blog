//
//  LEOSUnfairLock.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/25.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEOSUnfairLock.h"
#import <os/lock.h>
// 自旋锁的替代方案：区别在于，不会忙等，而是休眠
@interface LEOSUnfairLock ()
@property (nonatomic, assign) os_unfair_lock lock; // 存钱和取钱的锁
@end
@implementation LEOSUnfairLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}
// 卖票
- (void)__sellTicket {
    static os_unfair_lock lock;
    os_unfair_lock_lock(&lock);
    [super __sellTicket];
    os_unfair_lock_unlock(&lock);
}
// 取钱
- (void)__takeMoney {
    os_unfair_lock_lock(&_lock);
    [super __takeMoney];
    os_unfair_lock_unlock(&_lock);
}
// 存钱
- (void)__saveMoney {
    os_unfair_lock_lock(&_lock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_lock);
}
@end

/*
 os_unfair_lock 用来代替OSSpinLock的技术方案
 
    从底层调用来看，自旋锁和os_unfair_lock的区别，前者等待线程处于忙等，而后者等待线程处于休眠状态。
 
 */
