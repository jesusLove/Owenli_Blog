//
//  LEPermanentThread.m
//  XMG_RunLoop_线程保活
//
//  Created by lqq on 2018/9/20.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEPermanentThread.h"
#import "LEThread.h"

@interface LEPermanentThread()
@property (nonatomic, strong) LEThread *innerThread;
@end

@implementation LEPermanentThread
BOOL isKeepingRunLoop = YES;
- (instancetype)init
{
    self = [super init];
    if (self) {
        isKeepingRunLoop = YES;
        self.innerThread = [[LEThread alloc] initWithBlock:^{
            // 添加一个NSPort防止NSRunLoop销毁
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            while (isKeepingRunLoop && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        }];
    }
    return self;
}
- (void)run {
    if (!self.innerThread) {
        return;
    }
    [self.innerThread start];
}
- (void)stop {
    if (!self.innerThread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}
- (void)executeTaskWithTask:(LEPermanentThreadTask)task {
    // 线程是否为空
    if (!self.innerThread || !task) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    
    [self stop];
}
#pragma mark - Private Method
- (void)__stop {
    isKeepingRunLoop = NO;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}
- (void)__executeTask:(LEPermanentThreadTask)task {
    task();
}


@end
