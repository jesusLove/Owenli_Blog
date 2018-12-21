//
//  LELaunchManager.h
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/17.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LELaunchManager : NSObject

@property (nonatomic, strong, readonly) UIViewController *currentRootVC;

//@property (nonatomic, strong, readonly) UITabBarController *tabBarController;

+ (LELaunchManager *)shareInstance;

/**
 初始化，启动
 */
- (void)launchInWindow: (UIWindow *)window;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
