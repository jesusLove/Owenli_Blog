//
//  LETimeProxy.m
//  XMG_Memory_DisplayLink&NSTimer
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LETimeProxy.h"

@implementation LETimeProxy
+ (instancetype)proxyWithTarget:(id)target {
    LETimeProxy *proxy = [LETimeProxy alloc];
    proxy.target = target;
    return proxy;
}

//消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.target methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.target];
}

@end

/*
 通过中间对象的方法解决循环引用。继承自NSProxy虚类
 */
