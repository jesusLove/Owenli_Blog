//
//  LETimer.m
//  XMG_Memory_定时器
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LETimer.h"

@interface LETimer ()
@end

static NSMutableDictionary *kTimers; // 存放生成的timer
static dispatch_semaphore_t semaphore_;
@implementation LETimer

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kTimers = [NSMutableDictionary dictionary];
    });
    
    semaphore_ = dispatch_semaphore_create(1);
}
+ (NSString *)executeWithTarget:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
    if (!target || !selector) {
        return nil;
    }
    return [self executeWithTask:^{
        if ([target respondsToSelector:selector]) {
//            强制关闭警告
#pragma clang diagnosetic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    } start:start interval:interval repeats:repeats async:async];
}

+ (NSString *)executeWithTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
    
    if (!task || start < 0 || (interval <= 0 && repeats)) {
        return nil;
    }
  
    // 创建队列
    dispatch_queue_t queue = async ? dispatch_queue_create("com.lqq.time", DISPATCH_QUEUE_SERIAL) : dispatch_get_main_queue();
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(start * NSEC_PER_SEC)), (uint64_t)(interval * NSEC_PER_SEC), 0);
    

    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    NSString *name = [NSString stringWithFormat:@"%zd", kTimers.count];
    // 存在字典中
    [kTimers setObject:timer forKey:name];
    dispatch_semaphore_signal(semaphore_);
    
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    dispatch_resume(timer);
    return name;
}

+ (void)cancelTask:(NSString *)name {
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    // timer存在才可以取消
    if (![kTimers.allKeys containsObject:name]) {
        return;
    }
    dispatch_source_cancel(kTimers[name]);
    [kTimers removeObjectForKey:name];
    dispatch_semaphore_signal(semaphore_);
}

@end

/*
    使用信号控制字典的写入和访问
 */
