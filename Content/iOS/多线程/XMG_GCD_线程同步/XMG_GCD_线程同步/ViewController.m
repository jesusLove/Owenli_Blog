//
//  ViewController.m
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LEOSSpinLock.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 验证自旋锁
    LEOSSpinLock *lockDemo = [[LEOSSpinLock alloc] init];
    [lockDemo sellTest];
    [lockDemo moneyTest];
}


@end
