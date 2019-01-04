//
//  UIViewController+Trace.m
//  RuntimeMessage
//
//  Created by lqq on 2018/4/28.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "UIViewController+Trace.h"
#import <objc/runtime.h>
#import "Aspects.h"
#import "TraceHandler.h"

#pragma mark - 1. SwizzleMethod 实现埋点功能
/**
 使用 swizzleMethod 实现埋点功能。
 
 即使不在每个UIViewController中引入，也可以使用该功能。
 */
@implementation UIViewController (Trace)

//+ (void)load {
//    swizzleMethod([self class], @selector(viewWillAppear:), @selector(swizzled_viewDidAppear:));
//}
//
//- (void)swizzled_viewDidAppear:(BOOL)animated {
//    [self swizzled_viewDidAppear:animated];
//
//    NSString *className = NSStringFromClass([self class]);
//    [TraceHandler traceStatusWithName:className];
//}
//
//void swizzleMethod(Class class, SEL originalSelector, SEL swizzleSelector) {
//
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzleMethod = class_getInstanceMethod(class, swizzleSelector);
//
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//
//    if (didAddMethod) {
//        class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzleMethod);
//    }
//}

#pragma mark - 2. 在VC分类中使用`Aspects`

//+ (void)load {
//    
//    [UIViewController aspect_hookSelector:@selector(viewDidAppear:)
//                              withOptions:AspectPositionAfter
//                               usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
//                                                NSString *className = NSStringFromClass([[aspectInfo instance] class]);
//                                                [TraceHandler traceStatusWithName:className];
//                                            }
//                                    error:NULL];
//    
//}
//



@end
