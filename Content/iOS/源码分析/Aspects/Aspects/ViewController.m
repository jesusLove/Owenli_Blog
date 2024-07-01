//
//  ViewController.m
//  Aspects
//
//  Created by LQQ on 2019/1/16.
//  Copyright © 2019 Elink. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "Aspects.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SecondViewController *vc = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

    [vc aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^{
        NSLog(@"secondViewController did disappear");
    } error:nil];
    [vc aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info){
        SecondViewController *vc = info.instance;
        NSLog(@"dealloc %@ %@", info.instance, vc.view.backgroundColor);
    } error:nil];
}


@end
