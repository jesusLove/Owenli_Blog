//
//  LEPthreadRWLock.m
//  XMG_GCD_多读单写解决方案
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEPthreadRWLock.h"

@interface LEPthreadRWLock ()
@property (nonatomic, assign) pthread_rwlock_t rwlock;
@end
@implementation LEPthreadRWLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


@end
