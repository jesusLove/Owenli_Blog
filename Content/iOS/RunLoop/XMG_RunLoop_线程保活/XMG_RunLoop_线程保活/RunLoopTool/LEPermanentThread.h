//
//  LEPermanentThread.h
//  XMG_RunLoop_线程保活
//
//  Created by lqq on 2018/9/20.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
// 封装库，方便使用

typedef void (^LEPermanentThreadTask)(void);
@interface LEPermanentThread : NSObject

/**
 开启线程
 */
- (void)run;

/**
 销毁线程
 */
- (void)stop;

/**
 执行一个任务
 */
- (void)executeTaskWithTask:(LEPermanentThreadTask)task;


@end
