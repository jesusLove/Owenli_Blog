//
//  LENSCondition.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/25.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LENSCondition.h"
@interface LENSCondition ()
@property (nonatomic, strong) NSCondition *condition;
@property (nonatomic, strong) NSMutableArray *data;
@end
@implementation LENSCondition
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.condition = [[NSCondition alloc] init];
        self.data = [NSMutableArray array];
    }
    return self;
}

// 删除
- (void)__remove {
    NSLog(@"__remove ---- beigin");
    // 删除前保证有值
    [self.condition lock];
    if (self.data.count == 0) {
        // 等待，休眠并释放锁。等待别的线程唤醒，之后加锁。
        [self.condition wait];
    }
    [self.data removeLastObject];
    NSLog(@"%s", __func__);
    [self.condition unlock];
}
// 添加
- (void)__add {
    NSLog(@"%s", __func__);
    [self.condition lock];
    [self.data addObject:@"Test"];
    [self.condition signal]; // 唤醒条件等待的线程
    [self.condition unlock];
}

- (void)otherTest {
    // ①
    [[[NSThread alloc] initWithTarget:self selector:@selector(__remove) object:nil] start];
    // ②
    [[[NSThread alloc] initWithTarget:self selector:@selector(__add) object:nil] start];
    
    /*
     线程1需要等待线程2完成后才能进行。注意：添加和删除执行顺序是不确定的。
     */
    
}
@end
