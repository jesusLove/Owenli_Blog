//
//  LELaunchManager.m
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/17.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LELaunchManager.h"
#import "ViewController.h"

@interface LELaunchManager ()

@property (nonatomic, weak) UIWindow *window;

@end
@implementation LELaunchManager

+ (LELaunchManager *)shareInstance {
    static LELaunchManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)launchInWindow:(UIWindow *)window {
    self.window = window;
    
    // 根据登陆和未登录状态切换到不同的界面
    ViewController *vc = [[ViewController alloc] init];
    [self setCurrentRootVC:vc];
}
- (void)setCurrentRootVC:(UIViewController * _Nonnull)currentRootVC {
    _currentRootVC = currentRootVC;
    UIWindow *window = self.window ? self.window : [UIApplication sharedApplication].keyWindow;
    window.rootViewController = currentRootVC;
    [window lee_removeAllSubviews];
    [window addSubview:currentRootVC.view];
    [window makeKeyAndVisible];
}
@end
