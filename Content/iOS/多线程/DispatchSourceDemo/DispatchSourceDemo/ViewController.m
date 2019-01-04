//
//  ViewController.m
//  DispatchSourceDemo
//
//  Created by LQQ on 2019/1/4.
//  Copyright © 2019 Elink. All rights reserved.
//

#import "ViewController.h"
#import "LEADButton.h"
@interface ViewController ()
@property (nonatomic, strong) LEADButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.btn = [[LEADButton alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    [self.view addSubview:self.btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.btn startRoundDispathTimerWithDuration:10];
}
@end
