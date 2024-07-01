//
//  ViewController.m
//  LE_Runtime_应用示例
//
//  Created by lqq on 2018/10/25.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LEPerson.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LEPerson *person = [[LEPerson alloc] init];
    [person study];
    [person play];
}


@end
