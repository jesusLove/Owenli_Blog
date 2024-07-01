//
//  LEMutexLockRecursive.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/25.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEMutexLockRecursive.h"
#import <pthread.h>

@interface LEMutexLockRecursive ()
@property (nonatomic, assign) pthread_mutex_t lock;
@end
@implementation LEMutexLockRecursive

- (void)__initLock:(pthread_mutex_t *)lock {
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // 设置为普通锁
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); // 设置为递归锁
    // 初始化锁
    pthread_mutex_init(lock, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __initLock:&_lock];
    }
    return self;
}

- (void)otherTest {
    pthread_mutex_lock(&_lock);
    
    NSLog(@"%s", __func__);
    
    static int count = 0;
    if (count < 10) {
        count ++;
        [self otherTest];
    }
    pthread_mutex_unlock(&_lock);
}

// ==========普通锁递归调用产生死锁=============
//- (void)otherTest {
//    pthread_mutex_lock(&_lock);
//    NSLog(@"%s", __func__);
//    [self test2];
//    pthread_mutex_unlock(&_lock);
//}
//
//- (void)test2 {
//    pthread_mutex_lock(&_lock);
//    NSLog(@"%s", __func__);
//    pthread_mutex_unlock(&_lock);
//}


- (void)dealloc {
    // 销毁锁
    pthread_mutex_destroy(&_lock);
}
@end
