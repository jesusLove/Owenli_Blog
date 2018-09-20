//
//  LEPermanentViewController.m
//  XMG_RunLoop_线程保活
//
//  Created by lqq on 2018/9/20.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEPermanentViewController.h"
#import "LEPermanentThread.h"

@interface LEPermanentViewController ()
@property (nonatomic, strong) LEPermanentThread *thread;
@end

@implementation LEPermanentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thread = [[LEPermanentThread alloc] init];
    // 启动
    [self.thread run];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    __weak __typeof(self)weakSelf = self;
    [self.thread executeTaskWithTask:^{
        [weakSelf test];
    }];
}
- (void)test {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}
- (IBAction)stopThread:(UIButton *)sender {
    [self.thread stop];
}

@end
