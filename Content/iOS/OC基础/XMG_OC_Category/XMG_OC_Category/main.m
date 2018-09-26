//
//  main.m
//  XMG_OC_Category
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEPerson.h"
#import "LEPerson+Run.h"
#import "LEPerson+Play.h"


void category_test_1() {
    LEPerson *person = [[LEPerson alloc] init];
    
    [person eat];
    
    [person run];
    
    [person play];
    
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // category使用
//        category_test_1()

    }
    return 0;
}


/*
 
 Category实现原理
    Category编译后的底层结构是category_t结构体，里面存放着分类的对象方法、类方法、属性、协议等信息。
    在运行时会将数据合并到，主类中去。源码runtime-new.h中
 
 和扩展的区别是什么？
    扩展在编译的时候，它的数据就已经包含在类信息中。
    分类需要在运行时，才会将数据合并到类信息中。
 
 分类的访问过程是怎么样的？
 
 
 */

