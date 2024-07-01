
//
//  LEAtomic.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/25.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEAtomic.h"

@interface LEAtomic ()
//`atomic`用于保证属性`setter`和`getter`的原子性操作，相当于对`setter`和`getter`内部加了同步锁。它并不能保证使用属性的使用过程是线程安全的。
@property (atomic, strong) NSString *name;

@end

@implementation LEAtomic

// 参考源码：objc4中objc_accessors.mm
// 不能保证使用属性的过程是线程安全的

// 使用atomic比较消耗性能

@end
