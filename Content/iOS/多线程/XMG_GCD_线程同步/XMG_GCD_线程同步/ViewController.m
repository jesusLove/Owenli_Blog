//
//  ViewController.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LEOSSpinLock.h"
#import "LEOSUnfairLock.h"
#import "LEMutexLock.h"
#import "LEMutexLockRecursive.h"
#import "LEMutexLockCondition.h"
#import "LENSLock.h"

#import "LENSCondition.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 验证自旋锁
//    LEOSSpinLock *lockDemo = [[LEOSSpinLock alloc] init];
//    [lockDemo sellTest];
//    [lockDemo moneyTest];
    
    // 验证 os_unfair_lock
//    LEOSUnfairLock *lockDemo = [[LEOSUnfairLock alloc] init];
//    [lockDemo sellTest];
//    [lockDemo moneyTest];

    // 验证 pthread_mutex
//    LEMutexLock *lock = [[LEMutexLock alloc] init];
//    [lock sellTest];
//    [lock moneyTest];
    
    // 验证递归调用 产生死锁的问题
//    LEMutexLockRecursive *lock = [[LEMutexLockRecursive alloc] init];
//    [lock otherTest];
    
    // 验证递归锁
//    LEMutexLockRecursive *lock = [[LEMutexLockRecursive alloc] init];
//    [lock otherTest];
//    条件判断
//    LEMutexLockCondition *lock = [[LEMutexLockCondition alloc] init];
//    [lock otherTest];
    
    
    // NSLock验证
//    LENSLock *lock = [[LENSLock alloc] init];
//    [lock sellTest];
//    [lock moneyTest];
    
    // NSCondition验证
    LENSCondition *lock = [[LENSCondition alloc] init];
    [lock otherTest];
    
}


@end
