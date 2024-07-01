//
//  LEPerson.h
//  XMG_OC_KVO原理
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

// 通过KVO，监测age，KVO的实现原理
@interface LEPerson : NSObject
@property (nonatomic, assign) int age;
- (void)test;

//手动触发KVO
- (void)testKVO;
@end
