//
//  LENetworkDownloadAgency.h
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENetworkHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface LENetworkDownloadAgency : NSObject

- (void)sendDownloadRequest:(NSString *)url
        filePath:(NSString *)downloadFilePath
       resumable:(BOOL)resumable
        progress:(LEDownloadProgressBlock)progressBlock
         success:(LEDownloadSuccessBlock)successBlock
         failure:(LEDownloadFailureBlock)failureBlock;

@end

NS_ASSUME_NONNULL_END
