//
//  LETimeProxy.h
//  XMG_Memory_DisplayLink&NSTimer
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LETimeProxy : NSProxy
+ (instancetype)proxyWithTarget:(id)target;
@property (nonatomic, weak) id target;
@end
/*
 
 继承NSProx优点，效率高，不用进行方法查找和动态解析，直接进行消息转发。
 
 如果继承自NSObject会去搜索方法。
 */
