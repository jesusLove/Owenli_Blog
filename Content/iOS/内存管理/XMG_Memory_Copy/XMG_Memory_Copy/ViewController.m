//
//  ViewController.m
//  XMG_Memory_Copy
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LEPerson.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LEPerson *person = [[LEPerson alloc] init];
    person.data = [NSArray arrayWithObjects:@"aaa", nil];
    
    [person release];
}
@end

/*
 拷贝：为了修改对象，通过修改副本来保持原来对象不变。
 
 拷贝分为：深拷贝 和 浅拷贝
 
 NSString   NSArray  NSDictionary : 使用copy进行浅拷贝，使用mutableCopy进行深拷贝
 NSMutableString NSMutableArray NSMutableDictionary: 使用copy和mutableCopy都是深拷贝
 
 iOS中提供了两种拷贝方法：
    不可变：copy ：产生不可变副本
    可变：mutableCopy ： 产生可变副本

 */


/*
 引用计数值存放在哪里？
 
 ①：首先存放在ISA指针中，ISA指针提供19位存放引用计数。
 ②：如果ISA无法存放，则会存放到SidleTable中。当前对象的地址作为Key。
 
 weak指针的实现原理：弱引用对象，当对象销毁后，自动置为nil。
 
 对象销毁时会调用dealloc，其中会将所有的弱引用置空。
 
 __unsafe_unretained指针：不安全的弱指针，对象销毁指针并不会清空，成为野指针。
 
 */
