//
//  LEMutexLockCondition.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/25.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEMutexLockCondition.h"
#import <pthread.h>

@interface LEMutexLockCondition ()
@property (nonatomic, assign) pthread_mutex_t lock;
@property (nonatomic, assign) pthread_cond_t cond;
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation LEMutexLockCondition
- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        pthread_cond_init(&_cond, NULL);
        self.data = [NSMutableArray array];
    }
    return self;
}

// 删除
- (void)__remove {
     NSLog(@"%s", __func__);
    // 删除前保证有值
    pthread_mutex_lock(&_lock);
    if (self.data.count == 0) {
        // 等待，休眠并释放锁。等待别的线程唤醒，之后加锁。
        pthread_cond_wait(&_cond, &_lock);
        NSLog(@"%s", __func__);
    }
    [self.data removeLastObject];
   
    pthread_mutex_unlock(&_lock);
}
// 添加
- (void)__add {
    NSLog(@"%s", __func__);
    pthread_mutex_lock(&_lock);
    [self.data addObject:@"Test"];
    pthread_cond_signal(&_cond); // 唤醒条件等待的线程
    pthread_mutex_unlock(&_lock);
}

- (void)otherTest {
    // ①
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    // ②
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
    
    /*
     线程1需要等待线程2完成后才能进行。
     */
    
    
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
    pthread_cond_destroy(&_cond);
}
@end
