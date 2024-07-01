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


/**
 关联对象的行为。
 
 枚举类型objc_AssociationPolicy中定义关联对象的行为。

 OBJC_ASSOCIATION_ASSIGN : 弱引用assign
 OBJC_ASSOCIATION_RETAIN_NONATOMIC : strong + nonatomic
 OBJC_ASSOCIATION_COPY_NONATOMIC: copy + nonatomic
 OBJC_ASSOCIATION_RETAIN: strong + atomic
 OBJC_ASSOCIATION_COPY: copy + atomic
 
 
 在WWDC发布的内存销毁表，关联对象的生命周期要比对象本身释放的晚很多。
 它们会在被 NSObject -dealloc 调用的 object_dispose() 方法中释放。
 
 清除对象关联。
 
 不要使用`objc_removeAssociatedObjects()`，这个方法会删除所有的属性。
 
 可以调用`objc_setAssociatedObject`方法并传入一个nil值来清除一个关联。
 
 */
- (void)setDefaultColor:(UIColor *)defaultColor {
    objc_setAssociatedObject(self, &kDefaultColorKey, defaultColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)defaultColor {
    return objc_getAssociatedObject(self, &kDefaultColorKey);
}

@end
