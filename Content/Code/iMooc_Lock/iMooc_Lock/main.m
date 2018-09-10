//
//  main.m
//  iMooc_Lock
//
//  Created by lqq on 2018/9/4.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSLockTest.h"
void testSync () {
    NSObject *obj = [NSObject new];
    dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(global_queue, ^{
        @synchronized (obj) {
            NSLog(@"aaaa");
        }
    });
    // 对obj进行加锁处理，只有等待前一个block执行完毕才会进行下一个。
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        testSync();
        NSLockTest *obj = [[NSLockTest alloc] init];
        NSLock *lock = [[NSLock alloc] init];
        dispatch_queue_t global_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // 线程1
        dispatch_async(global_queue, ^{
            [lock lock];
            [obj method1];
            [lock unlock];
        });
    }
    return 0;
}

