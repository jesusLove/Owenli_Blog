//
//  ViewController.m
//  XMG_RunLoop_线程保活
//
//  Created by lqq on 2018/9/20.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "LETestViewController.h"
#import "LEThread.h"

@interface LETestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *runBtn;
@property (nonatomic, strong) LEThread  *thread;
@end

BOOL isKeepRunLoop = YES; //全局变量

@implementation LETestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.thread = [[LEThread alloc] initWithBlock:^{
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (isKeepRunLoop && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
        NSLog(@"%s --- end -----", __func__);
    }];
    [self.thread start];
    NSLog(@"创建子线程成功");
}
- (void)stopThread {

    isKeepRunLoop = NO;
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"停止RunLoop: %s", __func__);
    self.thread = nil;
}

// 运行测试任务
- (IBAction)runTest:(UIButton *)sender {
    if (!self.thread) {
        return;
    };
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)test {
    NSLog(@"执行任务：%s %@", __func__, [NSThread currentThread]);
}


// 点击按键停止子线程
- (IBAction)stopBtn:(UIButton *)sender {
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}
// 控制器销毁
- (void)dealloc {
    NSLog(@"控制器销毁了：%s", __func__);
    // 停止RunLoop循环, 最后
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}
@end
