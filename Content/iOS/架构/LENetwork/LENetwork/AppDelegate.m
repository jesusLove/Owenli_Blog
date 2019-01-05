//
//  AppDelegate.m
//  LENetwork
//
//  Created by LQQ on 2018/12/27.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

// 应用处于后台，且后台任务下载完成时回调
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    NSLog(@"应用处于后台，且后台任务下载完成时回调");
}

@end
