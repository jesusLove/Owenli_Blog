//
//  LEThread.m
//  XMG_RunLoop_线程保活
//
//  Created by lqq on 2018/9/20.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEThread.h"

@implementation LEThread
- (void)dealloc {
    NSLog(@"线程销毁了：%s", __func__);
}
@end
