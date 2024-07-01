//
//  LESDKManager.m
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/21.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LESDKManager.h"
#import "LESDKConfigKey.h"

@implementation LESDKManager

+ (LESDKManager *)sharedInstance {
    static LESDKManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (void)launchInWindow:(id)window {
    
    // 友盟统计
    
    // 日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24;
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}
@end
