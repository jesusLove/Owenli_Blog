//
//  ViewController.m
//  XMG_Memory_TaggedPointer
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()
@property(nonatomic, copy) NSString *target;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test4];
}
- (void)test1 {
    NSNumber *number1 = @10;
    NSNumber *number2 = @11;
    NSNumber *number3 = @12;
    
    NSLog(@"%p %p %p", number1, number2, number3); // 根据地址能查看到是否是Tagged Pointer。
}

// 一道面试题
// 发生了crash
- (void)test2 {
    // 多线程访问，在setter方法中多次释放，导致坏内存访问。
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10000; i ++) {
        dispatch_async(queue, ^{
            // 加锁
            self.target = [NSString stringWithFormat:@"asdfasfasdf%d", i];
            // 解锁
        });
    }
    /*
     解决方案可以对self.target赋值进行加锁处理。
     */
}

// 不会发生crash
// 原因：此时self.target是一个tagged Pointer。
- (void)test3 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 10000; i ++) {
        dispatch_async(queue, ^{
            self.target = [NSString stringWithFormat:@"abc%d", i];
        });
    }
}


- (void)test4 {
    NSString *str1 = [NSString stringWithFormat:@"asdfalsdfjlasdkfjlasd"];
    NSString *str2 = [NSString stringWithFormat:@"asd"];
    NSLog(@"%@ %@", [str1 class], [str2 class]);
    // __NSCFString NSTaggedPointerString
    NSLog(@"%p %p", str1, str2);
    // 0x6040002424c0 0xa000000006473613
}



@end

/*
 从64bit开始，iOS引入了Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储
 
 在没有使用Tagged Pointer之前， NSNumber等对象需要动态分配内存、维护引用计数等，NSNumber指针存储的是堆中NSNumber对象的地址值
 
 使用Tagged Pointer之后，NSNumber指针里面存储的数据变成了：Tag + Data，也就是将数据直接存储在了指针中
 
 当指针不够存储数据时，才会使用动态分配内存的方式来存储数据
 
 objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销
 
 如何判断一个指针是否为Tagged Pointer？
 iOS平台，最高有效位是1（第64bit）
 Mac平台，最低有效位是1
 
 */
