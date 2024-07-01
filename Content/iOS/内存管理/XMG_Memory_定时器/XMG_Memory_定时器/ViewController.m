//
//  ViewController.m
//  XMG_Memory_定时器
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LETimer.h"

@interface ViewController ()
@property (nonatomic, strong) dispatch_source_t timer;

@property(nonatomic, copy) NSString *timerName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self gcdTimer];
    
//    self.timerName = [LETimer executeWithTask:^{
//        NSLog(@"timer");
//    } start:2.0 interval:1.0 repeats: YES async: YES];
    
    self.timerName = [LETimer executeWithTarget:self selector:@selector(test) start:0 interval:1.0 repeats:YES async:NO];
}
- (void)test {
    NSLog(@"aaaa");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [LETimer cancelTask:self.timerName];
}




- (void)gcdTimer {
    dispatch_queue_t queue = dispatch_get_main_queue();
    // 创建一个定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    NSTimeInterval start = 2; // 2秒后开始
    NSTimeInterval interval = 1.0; // 时间间隔1秒
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(start * NSEC_PER_SEC)), (uint64_t)(interval * NSEC_PER_SEC), 0);
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"111");
    });
    // 启动定时器
    dispatch_resume(timer);
    self.timer = timer;
}

@end


/*
 定时器问题：
 
    NSTimer依赖于RunLoop，如果RunLoop的任务过于繁重，可能导致NSTimer不准时。
 
    GCD定时器准时，使用系统内核实现。
 
 */
