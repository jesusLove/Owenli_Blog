//
//  ViewController.m
//  OC语法规范
//
//  Created by LQQ on 2019/2/20.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "LEView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LEView *view = [[LEView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(30, 30, 90, 90)];
    topView.backgroundColor = [UIColor greenColor];
    [view addSubview:topView];
    
    
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [topView addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)sender {
    NSLog(@"啦啦啦啦");
}

@end
