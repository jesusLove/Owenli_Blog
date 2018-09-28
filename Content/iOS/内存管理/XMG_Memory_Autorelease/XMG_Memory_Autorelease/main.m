//
//  main.m
//  XMG_Memory_Autorelease
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEPerson.h"

// 在MRC中

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // objc_autoreleasePoolPush()
        
        LEPerson *person = [[LEPerson alloc] init];
        [person autorelease];
        
        // objc_autoreleasePoolPop()
        
    }
    return 0;
}

// 上面转成C++代码

/*
 数据结构
 
 
 // 结构体
 struct __AtAutoreleasePool {
     __AtAutoreleasePool() { // 构造函数，结构体创建的时候调用
            atautoreleasepoolobj = objc_autoreleasePoolPush();
        }
     ~__AtAutoreleasePool() { // 析构函数，在结构体销毁的时候调用
            objc_autoreleasePoolPop(atautoreleasepoolobj);
        }
     void * atautoreleasepoolobj;
 };
 
 int main(int argc, const char * argv[]) {
      {
        __AtAutoreleasePool __autoreleasepool; // 自动调用结构体构造函数
 
        LEPerson *person = ((LEPerson *(*)(id, SEL))(void *)objc_msgSend)((id)((LEPerson *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("LEPerson"), sel_registerName("alloc")), sel_registerName("init"));
         ((LEPerson *(*)(id, SEL))(void *)objc_msgSend)((id)person, sel_registerName("autorelease"));
 
        // 离开作用域会自动调用析构函数（objc_autoreleasePoolPop(autorelasepoolobj)
        }
     return 0;
}
 */

/*
 源码：
 void *
 objc_autoreleasePoolPush(void)
 {
     return AutoreleasePoolPage::push();
 }
 
 void
 objc_autoreleasePoolPop(void *ctxt)
 {
     AutoreleasePoolPage::pop(ctxt);
 }
 
 两者都通用AutoreleasePoolPage进行管理的。
 
 简化后：
 class AutoreleasePoolPage {
     magic_t const magic;
     id *next;
     pthread_t const thread;
     AutoreleasePoolPage * const parent;
     AutoreleasePoolPage *child;
     uint32_t const depth;
     uint32_t hiwat;
 }
 
 每一个AutoreleasePoolPage对象都占用4096字节内存，除了用来存放内部的成员变量，剩下的空间存储autorelease对象的地址。
 如果剩下的空间不够用会生成一个新的Page，通过child指向它。
 
 所有的AutoreleasePoolPage都是通过双向链表的结构连接在一起的。
 
 parent上一个，child指向下一个。
 
 */


/*
 AutoreleasePoolPage的存取过程？

 调用push方法会将一个POOL_BOUNDARY入栈，并且返回其内存地址。
 
 调用pop方法时传一个POOL_BOUNDARY的内存地址，从最后一个入栈的对象开始发送release消息，直到遇到POOL_BOUNDARY。
 
 id *next 指向了下一个能存放Autorelease对象地址的区域。
 
 
 */

/*
 
 Autorelease什么时候释放？
 
 1. 如果在autoreleasepool中，在pool结束后释放。
 2. 与Runloop的状态相关：
 
 iOS主线程中注册两个Observer:
 
 第一个：
 监听kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
 
 第二个：
 监听了KCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop(), objc_autoreleasePoolPush()
 监听了KCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()
 
 综上：在Runloop休眠之前或退出时释放autorelease对象。
 
 */
