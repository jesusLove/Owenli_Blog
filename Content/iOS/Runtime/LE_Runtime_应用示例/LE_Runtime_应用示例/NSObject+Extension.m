//
//  NSObject+Extension.m
//  LE_Runtime_应用示例
//
//  Created by lqq on 2018/10/25.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (void)setLe_count:(NSNumber *)le_count {
    objc_setAssociatedObject(self, @selector(le_count), le_count, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSNumber *)le_count {
    return objc_getAssociatedObject(self, @selector(le_count));
}

@end
