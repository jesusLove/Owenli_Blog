//
//  LENSConditionLock.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LENSConditionLock.h"
// 对NSCondition的进一步封装。
@interface LENSConditionLock ()
@property (nonatomic, strong) NSConditionLock *condition;
@end
@implementation LENSConditionLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 传入一个条件值
        self.condition = [[NSConditionLock alloc] initWithCondition:1]; // 并且设置条件值, 默认条件值为0
    }
    return self;
}

// 删除
- (void)__one {

    // 当锁内部条件值为1时，加锁。
//    [self.condition lockWhenCondition:1];
    [self.condition lock]; // 直接使用lock也可以
    sleep(1);
    NSLog(@"%s ①", __func__);
    [self.condition unlockWithCondition:2]; // 解锁，并且条件设置为2
}
// 添加
- (void)__two {
    
    [self.condition lockWhenCondition:2]; //条件值为2时，加锁。
    sleep(1);
    NSLog(@"%s ②", __func__);
    [self.condition unlockWithCondition:3];
}

// 添加
- (void)__three {
    
    [self.condition lockWhenCondition:3]; //条件值为2时，加锁。
    sleep(1);
    NSLog(@"%s ③", __func__);
    [self.condition unlock];
}

- (void)otherTest {
    // ①
    [[[NSThread alloc] initWithTarget:self selector:@selector(__one) object:nil] start];
    // ②
    [[[NSThread alloc] initWithTarget:self selector:@selector(__two) object:nil] start];
    // ③
    [[[NSThread alloc] initWithTarget:self selector:@selector(__three) object:nil] start];
    
    // 通过设置条件值，可以决定线程的执行顺序。
}
@end
