//
//  LEPerson.m
//  LE_Runtime_应用示例
//
//  Created by lqq on 2018/10/25.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LEPerson.h"
#import <objc/runtime.h>

@interface LEPerson () <NSCoding>

@end
@implementation LEPerson
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method playM = class_getInstanceMethod(self, @selector(play));
        Method studyM = class_getInstanceMethod(self, @selector(study));
        method_exchangeImplementations(playM, studyM);
    });
}

- (void)play {
    NSLog(@"%s", __func__);
}
- (void)study {
    NSLog(@"%s", __func__);
}

// 忽略的属性
- (NSArray *)ignoredNames {
    return @[];
}
// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {

    if (self = [super init]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if ([[self ignoredNames] containsObject:key]) {
                continue;
            }
            
            id value = [aDecoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}
// 归档
-(void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([[self ignoredNames] containsObject:key]) {
            continue;
        }
        
        id value = [self valueForKeyPath:key];
        
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);
}
@end
