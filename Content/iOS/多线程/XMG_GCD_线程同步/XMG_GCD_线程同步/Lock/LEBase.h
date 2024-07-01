//
//  LEBase.h
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEBase : NSObject
- (void)sellTest; // 卖票
- (void)moneyTest; //存取前
- (void)otherTest; // 其他操作

#pragma mark - 子类继承的方法
- (void)__saveMoney;
- (void)__takeMoney;
- (void)__sellTicket;


@end
