//
//  LEOSSpinLock.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEOSSpinLock.h"
#import <libkern/OSAtomic.h>
@interface LEOSSpinLock ()
@property (nonatomic, assign) OSSpinLock lock1; // 存取钱锁
@end
@implementation LEOSSpinLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock1 = OS_SPINLOCK_INIT;
    }
    return self;
}
#pragma mark - 重写父类的方法
// 下面两个方法需要使用同一把锁
- (void)__saveMoney {
    
    OSSpinLockLock(&_lock1);
    [super __saveMoney];
    OSSpinLockUnlock(&_lock1);
}
- (void)__takeMoney {
    OSSpinLockLock(&_lock1);
    [super __takeMoney];
    OSSpinLockUnlock(&_lock1);
}
//
- (void)__sellTicket {
    static OSSpinLock lock2 = OS_SPINLOCK_INIT;
    OSSpinLockLock(&lock2);
    [super __sellTicket];
    OSSpinLockUnlock(&lock2);
}
@end
