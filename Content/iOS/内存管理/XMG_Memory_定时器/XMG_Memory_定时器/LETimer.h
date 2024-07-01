//
//  LETimer.h
//  XMG_Memory_定时器
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LETimer : NSObject

/**
 @param task 任务
 @param start 多久后执行
 @param interval 时间间隔
 @param repeats 是否重复
 @param async 是否子线程
 @return 唯一标示
 */
+ (NSString *)executeWithTask:(void(^)(void))task
                  start:(NSTimeInterval)start
               interval:(NSTimeInterval)interval
                repeats:(BOOL)repeats
                  async:(BOOL)async;

+ (NSString *)executeWithTarget:(id)target
                       selector:(SEL)selector
                          start:(NSTimeInterval)start
                       interval:(NSTimeInterval)interval
                        repeats:(BOOL)repeats
                          async:(BOOL)async;

+ (void)cancelTask:(NSString *)name;
@end
