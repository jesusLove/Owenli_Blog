//
//  LENetworkConfig.m
//  LENetwork
//
//  Created by LQQ on 2018/12/28.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LENetworkConfig.h"

@implementation LENetworkConfig

+ (instancetype)shareConfig {
    static LENetworkConfig *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] init];
        shareInstance.timeoutSeconds = 30;
    });
    return shareInstance;
}

@end
