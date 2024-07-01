//
//  LENetworkConfig.h
//  LENetwork
//
//  Created by LQQ on 2018/12/28.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LENetworkConfig : NSObject

+ (instancetype)shareConfig;

@property (nonatomic, strong) NSString *baseUrl;

/**
 默认请求参数，默认值为nil
 */
@property (nonatomic, strong) NSDictionary *defaultParams;

/**
 自定义请求头,默认为nil
 */
@property (nonatomic, strong) NSDictionary *customHeaders;

/**
 超时时间，默认30s
 */
@property (nonatomic, assign) NSTimeInterval timeoutSeconds;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
