//
//  LENetworkAgency.h
//  LENetwork
//
//  Created by LQQ on 2018/12/29.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENetworkHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENetworkAgency : NSObject

- (void)sendRequest:(NSString * _Nonnull)url
             method:(LENetworkRequestMethod)method
         parameters:(id _Nullable)parameters
            success:(LENetworkSuccessBlock)successBlock
            failure:(LENetworkFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
