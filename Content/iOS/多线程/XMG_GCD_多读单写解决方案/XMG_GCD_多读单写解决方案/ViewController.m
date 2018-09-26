//
//  ViewController.m
//  XMG_GCD_多读单写解决方案
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>


@interface ViewController ()
@property (nonatomic, assign) pthread_rwlock_t rwlock;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化Lock
    pthread_rwlock_init(&_rwlock, NULL);
    
    [self pthreadRWLockTest];
    
}
// ① 读写锁使用方法 pthread_rwlock
- (void)pthreadRWLockTest {
    for (int i =0; i < 10; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(read) object:nil] start];
        [[[NSThread alloc] initWithTarget:self selector:@selector(write) object:nil] start];
    }
}

- (void)read {
    // 读加锁
    pthread_rwlock_rdlock(&_rwlock);
    sleep(1);
    NSLog(@"%s", __func__);
    
    pthread_rwlock_unlock(&_rwlock);
}

- (void)write {
    // 写加锁
    pthread_rwlock_wrlock(&_rwlock);
    NSLog(@"%s", __func__);
    sleep(1);
    pthread_rwlock_unlock(&_rwlock);
}

- (void)dealloc {
    pthread_rwlock_destroy(&_rwlock);
}

// ② dispatch_barrier_async

- (void)barrierAsyncTest {
    // 初始化队列
    dispatch_queue_t queue = dispatch_queue_create("com.lqq.queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 读
    dispatch_async(queue, ^{
        
    });
    
    // 写: 在写操作执行时，其他任务会被隔离无法执行直到写操作完成。
    dispatch_barrier_async(queue, ^{
        
    });
}


@end
