//
//  NSLockTest.m
//  iMooc_Lock
//
//  Created by lqq on 2018/9/4.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "NSLockTest.h"

@interface NSLockTest ()

@end
@implementation NSLockTest
- (void)method1 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"current thread = %@", [NSThread currentThread]);
}
- (void)method2 {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"current thread = %@", [NSThread currentThread]);
}

@end
