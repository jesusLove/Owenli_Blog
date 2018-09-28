//
//  LEPerson.m
//  XMG_Memory_Copy
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEPerson.h"

@implementation LEPerson

//- (void)setData:(NSArray *)data {
//    if (_data != data) {
//        [_data release];
//        _data = [data copy];
//    }
//}
//- (void)setData2:(NSArray *)data2 {
//    if (_data2 != data2) {
//        [_data2 release];
//        _data2 = [data2 retain];
//    }
//}

// 实现该方法
- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    LEPerson *p = [[LEPerson allocWithZone:zone] init];
    p.data = self.data;
    return p;
}
@end


