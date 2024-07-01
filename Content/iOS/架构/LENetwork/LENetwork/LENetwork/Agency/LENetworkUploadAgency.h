//
//  LENetworkUploadAgency.h
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LENetworkHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENetworkUploadAgency : NSObject
- (void)sendUploadRequest:(NSString * _Nonnull)url
               parameters:(id _Nullable)parameters
                   images:(NSArray<UIImage *>*)images
            compressRatio:(float)compressRatio
                     name:(NSString *)name
                 mimeType:(NSString *)mimeType
                 progress:(LEUploadProgressBlock)progressBlock
                  success:(LEUploadSuccessBlock)successBlock
                  failure:(LEUploadFailureBlock)failureBlock;
@end

NS_ASSUME_NONNULL_END
