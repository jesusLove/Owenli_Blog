//
//  LENetworkHeader.h
//  LENetwork
//
//  Created by LQQ on 2018/12/28.
//  Copyright © 2018 LQQ. All rights reserved.
//

#ifndef LENetworkHeader_h
#define LENetworkHeader_h

#import "AFNetworking.h"

// 请求回调
typedef void(^LENetworkSuccessBlock)(id responseObject);
typedef void(^LENetworkFailureBlock)(NSURLSessionTask *task, NSError *error, NSInteger statusCode);

// 上传
typedef void(^LEUploadSuccessBlock)(id responseObject);
typedef void(^LEUploadProgressBlock)(NSProgress *uploadProgress);
typedef void(^LEUploadFailureBlock)(NSURLSessionTask *task, NSError *error, NSInteger statusCode, NSArray<UIImage *>*uploadFailedImages);


// 下载
typedef void(^LEDownloadSuccessBlock)(id responseObject);
typedef void(^LEDownloadProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress);
typedef void(^LEDownloadFailureBlock)(NSURLSessionTask *task, NSError *error, NSString *resumableDataPath);

// 请求方式
typedef NS_ENUM(NSInteger, LENetworkRequestMethod) {
    LENetworkRequestMethodGET,
    LENetworkRequestMethodPOST,
    LENetworkRequestMethodPUT,
    LENetworkRequestMethodDELETE
};

@protocol LENetworkAgencyProtocol <NSObject>

- (void)addCustomHeaders;

- (id)addDefaultParametersWithCustomParameters:(id)parameters;

@end


#endif /* LENetworkHeader_h */
