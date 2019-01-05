//
//  LENetworkManager.h
//  LENetwork
//
//  Created by LQQ on 2018/12/29.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENetworkHeader.h"
#import "LENetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENetworkManager : NSObject

+ (instancetype)shareManager;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

#pragma mark - # GET & POST
- (void)GET:(NSString *)url
               success:(LENetworkSuccessBlock)successBlock
               failure:(LENetworkFailureBlock)failureBlock;

- (void)GET:(NSString *)url
            parameters:(id _Nullable)parameters
               success:(LENetworkSuccessBlock)successBlock
               failure:(LENetworkFailureBlock)failureBlock;

- (void)POST:(NSString *)url
             parameters:(id _Nullable)parameters
                success:(LENetworkSuccessBlock)successBlock
                failure:(LENetworkFailureBlock)failureBlock;

#pragma mark - # Cancel Request
- (void)cancelAllCurrentRequests;
- (void)cancelCurrentRequest:(NSString *)url;

#pragma mark - # Upload
- (void)UploadImages:(NSString *)url
                     parameters:(id _Nullable)parameters
                         images:(NSArray<UIImage *>*)images
                  compressRatio:(float)compressRatio
                           name:(NSString *)name
                       mimeType:(NSString *)mimeType
                       progress:(LEUploadProgressBlock)progressBlock
                        success:(LEUploadSuccessBlock)successBlock
                        failure:(LEUploadFailureBlock)failureBlock;


#pragma mark - # Download

- (void)Download:(NSString *)url
        filePath:(NSString *)downloadFilePath
        progress:(LEDownloadProgressBlock)progressBlock
         success:(LEDownloadSuccessBlock)successBlock
         failure:(LEDownloadFailureBlock)failureBlock;

- (void)Download:(NSString *)url
        filePath:(NSString *)downloadFilePath
       resumable:(BOOL)resumable
        progress:(LEDownloadProgressBlock)progressBlock
         success:(LEDownloadSuccessBlock)successBlock
         failure:(LEDownloadFailureBlock)failureBlock;


#pragma mark - # Suspend Downlaod
- (void)suspendAllDownloadRequest;
- (void)suspendDownloadRequest:(NSString *)url;
- (void)suspendDownloadRequests:(NSArray *)urls;


#pragma mark - # Resume Download
- (void)resumeAllDownloadRequests;
- (void)resumeDownloadRequest:(NSString *)url;
- (void)resumeDownloadRequests:(NSArray *)urls;


#pragma mark - # Cancel Download
- (void)cancelAllDownloadRequests;
- (void)cancelDownloadRequest:(NSString *)url;
- (void)cancelDownloadRequests:(NSArray *)urls;




@end

NS_ASSUME_NONNULL_END
