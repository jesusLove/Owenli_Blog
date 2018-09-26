//
//  main.m
//  XMG_OC_对象的本质
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <malloc/malloc.h>
#import "LEPerson.h"

void objc_test() {
    LEPerson *person = [[LEPerson alloc] init];
    
    NSLog(@"%zd", class_getInstanceSize([LEPerson class])); //实例对象，成员变量占用的大小
    // 8
    NSLog(@"%zd", malloc_size((__bridge const void *)(person))); // 获取指针执行内存地址的大小。
    // 16
    // xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main-arm64.cpp
    // 将main.m转为arm64架构的C++代码
    NSLog(@"Person实例：%p", person); //实例对象地址
    NSLog(@"Person类对象：%p", [person class]); // 类对象地址
    NSLog(@"Person类对象: %p", [LEPerson class]); // 类对象地址
    NSLog(@"Person元类对象： %p", object_getClass([person class])); //元类地址
    
    // 判断是否是元类
    NSLog(@"%d", class_isMetaClass(object_getClass([person class])));
    
    
    
}
/**
 一个对象占用多大空间的问题？
 系统分配了16字节给Person对象，通过malloc_size函数获得
 但Person对象内部只使用了8个字节的空间，64位环境下，通过class_getInstanceSize函数获得。
 */
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        objc_test();
        
    }
    return 0;
}

/*
 struct NSObject_IMPL {
    Class isa; // isa 指针占用8字节。
 };
 
 实例，类，元类

 instance
 
     通过alloc产生的对象，每次都会产生新的实例对象
     存放成员变量（包含isa）
 
 class
 
     每个类在内存中有且仅有一个class对象
     isa指针
     superCalss指针
     类的属性信息（@property）类的对象方法信息（Instance Method）
     类的协议信息(protocol) 类的成员变量信息（ivar）
 
 meta-class
 
     isa指针
     superClass指针
     类的类方法信息（class Method)
 */

