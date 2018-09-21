//
//  LEOSSpinLock.h
//  XMG_GCD_线程同步
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEBase.h"

/**
 自旋锁：不再安全，存在优先级反转问题。如果等待锁的线程优先级较高，他会一直占用CPU资源，优先级低的线程就无法释放锁
 */
@interface LEOSSpinLock : LEBase

@end
