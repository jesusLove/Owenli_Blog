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
#pragma mark - 方法替换(swizzle Method)
/**
    位置选择： + load & + initialize。
 
    `swizzling`应该在load中完成。
 
    OC中，每个类这两个方法都会自动调用。
 
    + load 是在一个类被初始装载时被调用
    + initialize 是在应用第一次调用该类的类方法或实例方法前调用。
 
    两个方法是可选的，推荐在 + load 中。
 
    在dispatch_once中完成，swizzling修改是全局性的，所以我们需要保证只执行一次即可。
 */

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(qqViewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzleMethod = class_getInstanceMethod(class, swizzledSelector);
        
        
        // 当添加类方法时，使用下面方式
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        // 判断swizzleMethod是否存在
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzleMethod);
        }
    });
}

/**
    下面并不会发生循环，因为`[self qqViewDidLoad]`方法调用的使用`viewDidLoad`。因为，此时`qqViewDidLoad`的实现方法一应被替换为`viewDidLoad`
 */
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

#pragma mark - 1. 动态方法解析
/**
 动态方法解析, 将消息转发给其他对象

 @param sel 方法
 @return 是否动态解析
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    if ([NSStringFromSelector(sel) isEqualToString:@"foo:"]) {
        class_addMethod([self class], sel, (IMP)fooMethod, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
void fooMethod (id obj, SEL _cmd) {
    NSLog(@"Doing foo");
}


#pragma mark - 2. 备用接收者
/**
 将消息转发给备用接收者

 @param aSelector 消息
 @return 备用接收者
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([NSStringFromSelector(aSelector) isEqualToString:@"foo:"]) {
        return [Person new]; // 返回Person对象，让person对象接收消息
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 3. 完整的消息转发
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
    Person *p = [Person new];
    if ([p respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:p];
    } else {
        [self doesNotRecognizeSelector:sel];
    }
}

@end
