//
//  LEPerson.m
//  XMG_OC_KVO原理
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LEPerson.h"

@implementation LEPerson
- (void)test {
    _age = 100;
}

- (void)testKVO {
    [self willChangeValueForKey:@"age"];
    _age = 100;
    [self didChangeValueForKey:@"age"];
}
@end
