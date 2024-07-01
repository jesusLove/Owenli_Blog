//
//  AppDelegate.m
//  iOSTemplateAPP
//
//  Created by lqq on 2018/12/17.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "AppDelegate.h"

#import "LESDKManager.h"
#import "LELaunchManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 初始化SDK
    [[LESDKManager sharedInstance] launchInWindow:self.window];
    // 初始化UI
    [[LELaunchManager shareInstance] launchInWindow:self.window];
    return YES;
}

@end
