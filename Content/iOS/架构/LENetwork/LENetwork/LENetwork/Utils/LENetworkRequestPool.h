//
//  LENetworkRequestPool.h
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LENetworkRequestModel;
@interface LENetworkRequestPool : NSObject

+ (LENetworkRequestPool *)sharePool;

- (NSMutableDictionary<NSString *, LENetworkRequestModel *> *)currentRequestModels;
// 添加
- (void)addRequestModel:(LENetworkRequestModel *)requestModel;

// 移除
- (void)removeRequestModel:(LENetworkRequestModel *)requestModel;

// 池中是否还有请求
- (BOOL)remainingCurrentRequests;

// 池中请求数量
- (NSInteger)currentRequestCount;

// 取消所有请求
- (void)cancelAllCurrentRequests;
// 取消指定URL的请求
- (void)cancelCurrentRequestWithUrl:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
