//
//  ViewReusePool.m
//  TableView重用机制
//
//  Created by lqq on 2018/8/3.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ViewReusePool.h"

@interface ViewReusePool()
@property (nonatomic, strong) NSMutableSet *waitUsedQueue;
@property (nonatomic, strong) NSMutableSet *usingQueue;
@end
@implementation ViewReusePool

- (instancetype)init
{
    self = [super init];
    if (self) {
        _waitUsedQueue = [NSMutableSet set];
        _usingQueue = [NSMutableSet set];
    }
    return self;
}

- (UIView *)dequeueReuseableView {
    UIView *view = [_waitUsedQueue anyObject];
    if (view == nil) {
        return nil;
    } else {
        [_waitUsedQueue removeObject:view];
        [_usingQueue addObject:view];
        return view;
    }
}

- (void)addUsingView:(UIView *)view {
    if (view == nil) {
        return;
    }
    // 添加到使用队列中
    [_usingQueue addObject:view];
}
// 重置重用池，清空使用队列
- (void)reset {
    UIView *view = nil;
    while ((view = [_usingQueue anyObject])) {
        
        // 从使用队列中移除
        [_usingQueue removeObject:view];
        // 添加到等待队列中
        [_waitUsedQueue addObject:view];
    }
}
@end
