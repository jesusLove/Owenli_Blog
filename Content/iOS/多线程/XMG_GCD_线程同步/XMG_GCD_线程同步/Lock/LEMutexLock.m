//
//  LEMutexLock.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/25.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEMutexLock.h"
#import <pthread.h>
// 不需要的时候需要销毁掉
// 通过设置属性，可以配置成递归锁，和条件锁。
@interface LEMutexLock ()
@property (nonatomic, assign) pthread_mutex_t lock;
@property (nonatomic, assign) pthread_mutex_t ticketLock;
@end

@implementation LEMutexLock

- (void)__initLock:(pthread_mutex_t *)lock {
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    // 设置为普通锁
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);
    // 初始化锁
    pthread_mutex_init(lock, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
    
//    可以直接将attr置NULL表示默认
//    pthread_mutex_init(lock, NULL);
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self __initLock:&_lock];
        [self __initLock:&_ticketLock];
    }
    return self;
}
- (void)__sellTicket {
    // 加锁
    pthread_mutex_lock(&_ticketLock);
    pthread_mutex_lock(&_lock);
    [super __sellTicket];
    // 解锁
    pthread_mutex_unlock(&_ticketLock);
    pthread_mutex_unlock(&_lock);
}

- (void)__takeMoney {
    pthread_mutex_lock(&_lock);
    
    [super __takeMoney];
    
    pthread_mutex_unlock(&_lock);
}
- (void)__saveMoney {
    pthread_mutex_lock(&_lock);
    
    [super __saveMoney];
    
    pthread_mutex_unlock(&_lock);
}
- (void)dealloc {
    // 销毁锁
    pthread_mutex_destroy(&_lock);
    pthread_mutex_destroy(&_ticketLock);
}
@end

/*
 pthread_mutex
    一种跨平台的锁
    互斥锁：等待锁的线程处于休眠状态。
 
    pthread_mutex通过设置参数可以成为递归锁、条件锁。
 
    NSLock是对mutex普通锁的封装
 
    NSRecursiveLock是对mutex递归锁的封装
 
    NSCondition是对mutex条件锁的封装
 
    NSConditionLock是对NSCondition的进一步封装
 
 */
