//
//  LESmeaphore.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LESmeaphore.h"

@interface LESmeaphore ()
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@end
@implementation LESmeaphore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.semaphore = dispatch_semaphore_create(5); // 设置并发数量
    }
    return self;
}

- (void)otherTest {
    for (int i = 0; i < 20; i ++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}
- (void)test {
    // 如果信号量的值<=0，当前线程就会进入休眠等待，直到信号量的值>0
    // 如果信号量的值>0，就减1，然后往下执行后面的代码
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    sleep(2);
    NSLog(@"test - %@", [NSThread currentThread]);
    // 让信号量的值增加1
    dispatch_semaphore_signal(self.semaphore);
}
@end


/*

信号量：
    控制线程的并发量。
    只有信号值大于0时，才能执行开启新的线程。
    dispatch_semaphore_wait() 信号值大于0时执行，并将信号值减一，然后开始执行后面的内容。
    如果信号值小于等于0时，当前线程进入休眠等待，直到信号的值大于0
 
    dispatch_semaphore_signal() 信号量的值增加1.
 */
