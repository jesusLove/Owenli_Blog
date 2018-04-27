//
//  NSObject+JSON.m
//  RuntimeMessage
//
//  Created by lqq on 2018/4/27.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "NSObject+JSON.h"
#import <objc/runtime.h>

@implementation NSObject (JSON)

/**
 
 类的属性和类型，存放到数组中。
 
 */
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [self init]) {
        // 1. 获取类所有的属性和类型
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *attributes = [NSMutableArray array];
        unsigned int outCount;
        // 获取所有属性
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0 ; i < outCount; i ++) {
            objc_property_t property = properties[i];
            // 获取属性名字
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            [keys addObject:propertyName];
            // 获取属性类型
            NSString *propertyAttribute = [NSString stringWithUTF8String:property_getAttributes(property)];
            [attributes addObject:propertyAttribute];
        }
        // 是否内存
        free(properties);
        
        for (NSString *key in keys) {
            if ([dict valueForKey:key] != nil) {
                [self setValue:[dict valueForKey:key] forKey:key];
            }
        }
    }
    return self;
}
@end
