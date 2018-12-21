//
//  LESDKManager.h
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/21.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LESDKManager : NSObject

+ (LESDKManager *)sharedInstance;

- (void)launchInWindow:(UIWindow *)window;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
