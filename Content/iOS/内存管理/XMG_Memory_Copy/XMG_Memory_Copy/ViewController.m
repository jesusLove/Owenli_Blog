//
//  ViewController.m
//  XMG_Memory_Copy
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
