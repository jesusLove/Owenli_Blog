//
//  ViewController.m
//  KVO
//
//  Created by lqq on 2018/4/28.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ViewController.h"


@interface Person : NSObject

@property (nonatomic, assign) NSInteger age;

@end

@implementation Person
@synthesize age = _age;

- (void)setAge:(NSInteger)age {
    _age = age;
}

- (NSInteger)age {
    return _age;
}

@end



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self observerAge];
}


- (void)observerAge {
    Person *p1 = [[Person alloc] init];
    Person *p2 = [[Person alloc] init];
    p1.age = 1;
    p1.age = 2;
    p2.age = 10;
    // 监听 p1 的 age 属性
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    
    // 打断点
    
    /**
     此时 p1->isa : Person
        p1->isa: Person
     */
    
    [p1 addObserver:self forKeyPath:@"age" options:options context:nil];
    
    /**
     
     执行完上一步后
     p1->isa指针指向 NSKVONotifying_Person
     p2->isa: Person
     
     当添加键值观察后，p1的isa指针指向了新的类对象，NSKVONotifying_Person是Person的子类。
     
     该类对象是运行时动态生成的。
     
     NSKVONotifyin_Person中的setage方法中其实调用了 Fundation框架中C语言函数 _NSsetIntValueAndNotify，_NSsetIntValueAndNotify内部做的操作相当于，首先调用willChangeValueForKey 将要改变方法，之后调用父类的setage方法对成员变量赋值，最后调用didChangeValueForKey已经改变方法。didChangeValueForKey中会调用监听器的监听方法，最终来到监听者的observeValueForKeyPath方法中。
     */
    
    p1.age = 10;
    [p1 removeObserver:self forKeyPath:@"age"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"对象%@的%@值改变%@", object, keyPath, change);
}

/**
 2018-04-28 16:39:00.367223+0800 KVO[58888:1538259] 对象<Person: 0x6040000129c0>的age值改变{
 kind = 1;
 new = 10;
 old = 2;
 }

 */



@end
