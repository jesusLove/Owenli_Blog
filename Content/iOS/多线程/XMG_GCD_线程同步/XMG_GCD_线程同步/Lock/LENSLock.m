//
//  LENSLock.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/25.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LENSLock.h"

// 对mutex的普通锁的封装
@interface LENSLock ()
@property (nonatomic, strong) NSLock* lock;
@property (nonatomic, strong) NSLock* ticketLock;
@end
@implementation LENSLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.lock = [[NSLock alloc] init];
        self.ticketLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)__sellTicket {
    [self.ticketLock lock];
    [super __sellTicket];
    [self.ticketLock unlock];
}

- (void)__saveMoney {
    [self.lock lock];
    [super __saveMoney];
    [self.lock unlock];
}
- (void)__takeMoney {
    [self.lock lock];
    [super __takeMoney];
    [self.lock unlock];
}
@end
