//
//  ViewController.m
//  RuntimeMessage
//
//  Created by lqq on 2018/4/27.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "UIView+DefaultColor.h"


@interface Person: NSObject<NSCoding>

@end

@implementation Person
- (void)foo:(id)sender {
    NSLog(@"Doing foo");
}

// NSCoding的自动归档和自动解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        unsigned int outCount;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}




@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    //关联对象
//    UIView *test = [UIView new];
//    test.defaultColor = [UIColor blackColor];
//    NSLog(@"%@", test.defaultColor);
    
    
    
        [self performSelector:@selector(foo:) withObject:nil];
    // 找不到`foo`的实现，会报错
    
    NSLog(@"系统ViewDidLoad");
}
#pragma mark - 方法替换

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(qqViewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, @selector(viewDidLoad));
        Method swizzleMethod = class_getInstanceMethod(class, @selector(qqViewDidLoad));
        
        // 判断swizzleMethod是否存在
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
    });
}
- (void)qqViewDidLoad {
    [self qqViewDidLoad];
    NSLog(@"替换方法");
}



#pragma mark - 消息转发
/**
    动态方法解析
    备用接收者
    完整转发
 */

/**
 动态方法解析

 @param sel 方法
 @return 是否动态解析
 */
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
////    NSLog(@"%@", NSStringFromSelector(sel));
//
//    if ([NSStringFromSelector(sel) isEqualToString:@"foo:"]) {
//        class_addMethod([self class], sel, (IMP)fooMethod, "v@:");
//        return NO;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//void fooMethod (id obj, SEL _cmd) {
//    NSLog(@"Doing foo");
//}

/**
 将消息转发给备用接收者

 @param aSelector 消息
 @return 备用接收者
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(foo)) {
//        return [Person new]; // 返回Person对象，让person对象接收消息
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}


//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSLog(@"forwardTargetForSelector");
//    return nil; // 进入下一步转发
//}


// 获取参数和返回值类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"foo:"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}
// 完整消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = anInvocation.selector;
    NSLog(@"%@", NSStringFromSelector(sel));
    Person *p = [Person new];
    if ([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    } else {
        [self doesNotRecognizeSelector:sel];
    }
}

@end
