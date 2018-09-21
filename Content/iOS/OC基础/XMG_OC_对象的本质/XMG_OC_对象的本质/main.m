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


/**
 一个对象占用多大空间的问题？
 */
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        LEPerson *person = [[LEPerson alloc] init];
        
        NSLog(@"%zd", class_getInstanceSize([LEPerson class])); //实例对象，成员变量占用的大小
        // 8
        NSLog(@"%zd", malloc_size((__bridge const void *)(person))); // 获取指针执行内存地址的大小。
        // 16
        // xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc main.m -o main-arm64.cpp
        // 将main.m转为arm64架构的C++代码
    }
    return 0;
}

/*
 struct NSObject_IMPL {
    Class isa; // isa 指针占用8字节。
 };
 
 */
