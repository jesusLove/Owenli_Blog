//
//  UIView+DefaultColor.m
//  RuntimeMessage
//
//  Created by lqq on 2018/4/27.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "UIView+DefaultColor.h"
#import <objc/runtime.h>

@implementation UIView (DefaultColor)

@dynamic defaultColor;

static char kDefaultColorKey;

- (void)setDefaultColor:(UIColor *)defaultColor {
    objc_setAssociatedObject(self, &kDefaultColorKey, defaultColor, OBJC_ASSOCIATION_RETAIN);
}
- (id)defaultColor {
    return objc_getAssociatedObject(self, &kDefaultColorKey);
}

@end
