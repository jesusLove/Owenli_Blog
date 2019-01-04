//
//  ImageFilter.m
//  DecorativePattern(装饰模式)
//
//  Created by lqq on 2018/5/12.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ImageFilter.h"
@implementation ImageFilter

- (instancetype)initWithImageComponent:(id<ImageComponent>)component {
    if (self = [super init]) {
        self.component = component;
    }
    return self;
}

- (void)apply {
    // 由子类重载，应用真正的滤镜
}
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *selectorName = NSStringFromSelector(aSelector);
    if ([selectorName hasPrefix:@"draw"]) {
        [self apply];
    }
    return self.component;
}

@end
