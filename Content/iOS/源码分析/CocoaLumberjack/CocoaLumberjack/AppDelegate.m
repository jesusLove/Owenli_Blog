//
//  AppDelegate.m
//  CocoaLumberjack
//
//  Created by LQQ on 2019/1/14.
//  Copyright © 2019 Elink. All rights reserved.
//

#import "AppDelegate.h"
#define LOG_LEVEL_DER ddLogLevel
#import "CocoaLumberjack.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [DDLog addLogger:[DDOSLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24小时
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
    
    return YES;
}

@end
