//
//  ViewController.m
//  XMG_Memory_DisplayLink&NSTimer
//
//  Created by lqq on 2018/9/26.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LETimeProxy.h"

@interface ViewController ()
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 发生循环引用
//    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkTest)];
//    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    //发生循环引用
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[LETimeProxy proxyWithTarget:self] selector:@selector(timeTest) userInfo:nil repeats:YES];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTest) userInfo:nil repeats:YES];
    
    
    // timer解决方案一：使用BlockAPI
//    __weak __typeof(self)weakSelf = self;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf timeTest];
//    }];
    
    
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.timer invalidate];
//}


- (void)timeTest {
    NSLog(@"%s", __func__);
}

- (void)linkTest {
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
    // 没有用的，已经强引用了，不会再调用
//    [self.link invalidate];
//    [self.timer invalidate];
}
@end

/*
 
 CADisplayLink & NSTimer 可能会出现的问题！
    CADisplayLink和NSTimer会对target产生强引用，如果target对他们产生强引用，那么就会引发循环引用。
    解决方案：
    ①： 使用block，通过weakSelf避免循环引用。注意weakSelf只能在Block中使用才能避免循环引用。
         // timer解决方案
         __weak __typeof(self)weakSelf = self;
         self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
         [weakSelf timeTest];
         }];
 
    ②：使用代理对象（NSProxy)
         NSProxy类
         使用中间对象的方法解决循环引用。通过消息转发机制将调用中间对象的方法转发给当前对象。
         CADisplayLink同NSTimer解决方式相同。
 
 
    NSProxy抽象类，直接进行消息转发。
 
 */
