//
//  LENetworkManager.m
//  LENetwork
//
//  Created by LQQ on 2018/12/29.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LENetworkManager.h"
#import "LENetworkAgency.h"
#import "LENetworkUploadAgency.h"
#import "LENetworkRequestPool.h"

@interface LENetworkManager ()
@property (nonatomic, strong) LENetworkAgency *requestAgency;
@property (nonatomic, strong) LENetworkUploadAgency *uploadAgency;
@end

@implementation LENetworkManager

+ (instancetype)shareManager {
    static LENetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
#pragma mark - GET & POST
- (void)GET:(NSString *)url
    success:(LENetworkSuccessBlock)successBlock
    failure:(LENetworkFailureBlock)failureBlock {
    [self GET:url parameters:nil success:successBlock failure:failureBlock];
}

- (void)GET:(NSString *)url parameters:(id)parameters success:(LENetworkSuccessBlock)successBlock failure:(LENetworkFailureBlock)failureBlock {
    [self.requestAgency sendRequest:url method:LENetworkRequestMethodGET parameters:parameters success:successBlock failure:failureBlock];
}

- (void)POST:(NSString *)url parameters:(id)parameters success:(LENetworkSuccessBlock)successBlock failure:(LENetworkFailureBlock)failureBlock {
    [self.requestAgency sendRequest:url method:LENetworkRequestMethodPOST parameters:parameters success:successBlock failure:failureBlock];
}

#pragma mark - # Cancel Request
- (void)cancelAllCurrentRequests {
    [[LENetworkRequestPool sharePool] cancelAllCurrentRequests];
}
- (void)cancelCurrentRequest:(NSString *)url {
    [[LENetworkRequestPool sharePool] cancelCurrentRequestWithUrl:url];
}


#pragma mark - Upload
- (void)UploadImages:(NSString *)url parameters:(id)parameters images:(NSArray<UIImage *> *)images compressRatio:(float)compressRatio name:(NSString *)name mimeType:(NSString *)mimeType progress:(LEUploadProgressBlock)progressBlock success:(LEUploadSuccessBlock)successBlock failure:(LEUploadFailureBlock)failureBlock {
    [self.uploadAgency sendUploadRequest:url parameters:parameters images:images compressRatio:compressRatio name:name mimeType:mimeType progress:progressBlock success:successBlock failure:failureBlock];
}

#pragma mark - Download
- (void)Download:(NSString *)url filePath:(NSString *)downloadFilePath progress:(LEDownloadProgressBlock)progressBlock success:(LEDownloadSuccessBlock)successBlock failure:(LEDownloadFailureBlock)failureBlock {
    [self Download:url filePath:downloadFilePath resumable:NO progress:progressBlock success:successBlock failure:failureBlock];
}

- (void)Download:(NSString *)url filePath:(NSString *)downloadFilePath resumable:(BOOL)resumable progress:(LEDownloadProgressBlock)progressBlock success:(LEDownloadSuccessBlock)successBlock failure:(LEDownloadFailureBlock)failureBlock {
    
}

#pragma mark - # Suspend Downlaod
- (void)suspendAllDownloadRequest {
    
}
- (void)suspendDownloadRequest:(NSString *)url {
    
}
- (void)suspendDownloadRequests:(NSArray *)urls {
    
}


#pragma mark - # Resume Download
- (void)resumeAllDownloadRequests {
    
}
- (void)resumeDownloadRequest:(NSString *)url {
    
}
- (void)resumeDownloadRequests:(NSArray *)urls {
    
}


#pragma mark - # Cancel Download
- (void)cancelAllDownloadRequests {
    
}
- (void)cancelDownloadRequest:(NSString *)url {
    
}
- (void)cancelDownloadRequests:(NSArray *)urls {
    
}



#pragma mark - # Setter & Getters
- (LENetworkAgency *)requestAgency {
    if (!_requestAgency) {
        _requestAgency = [[LENetworkAgency alloc] init];
    }
    return _requestAgency;
}

- (LENetworkUploadAgency *)uploadAgency {
    if (!_uploadAgency) {
        _uploadAgency = [[LENetworkUploadAgency alloc] init];
    }
    return _uploadAgency;
}
@end
