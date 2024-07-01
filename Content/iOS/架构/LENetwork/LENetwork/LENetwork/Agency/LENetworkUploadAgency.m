//
//  LENetworkUploadAgency.m
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import "LENetworkUploadAgency.h"
#import "LENetworkConfig.h"
#import "LENetworkRequestModel.h"
#import "LENetworkRequestPool.h"


@interface LENetworkUploadAgency ()<LENetworkAgencyProtocol>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
@implementation LENetworkUploadAgency
- (instancetype)init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        // RequestSerializer
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.requestSerializer.allowsCellularAccess = YES;
        _sessionManager.requestSerializer.timeoutInterval = [LENetworkConfig shareConfig].timeoutSeconds;
        
        // securityPolicy
        _sessionManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
        
        // ResponseSerializer
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"application/xml", @"text/xml",@"text/html", @"application/json",@"text/plain",nil];
        // Queue
        _sessionManager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
    }
    return self;
}
#pragma mark - Public Methods
- (void)sendUploadRequest:(NSString *)url
               parameters:(id)parameters
                   images:(NSArray<UIImage *> *)images
            compressRatio:(float)compressRatio
                     name:(NSString *)name
                 mimeType:(NSString *)mimeType
                 progress:(LEUploadProgressBlock)progressBlock
                  success:(LEUploadSuccessBlock)successBlock
                  failure:(LEUploadFailureBlock)failureBlock {
    if ([images count] == 0) {
        NSLog(@"上传失败：图片数量为0");
        return;
    }
    [self addCustomHeaders];
    
    NSString *methodStr = @"POST";
    NSString *completeUrlStr = [self p_completeRequestURLWithBaseURL:[LENetworkConfig shareConfig].baseUrl requestURL:url];;
    NSString *requestIdentifer = url;
    
    NSDictionary *completeParameters = [self addDefaultParametersWithCustomParameters:parameters];
    
    
    LENetworkRequestModel *uploadModel = [[LENetworkRequestModel alloc] init];
    uploadModel.requestUrl = completeUrlStr;
    uploadModel.uploadUrl = url;
    uploadModel.method = methodStr;
    uploadModel.parameters = completeParameters;
    uploadModel.imagesIdentifer = name;
    uploadModel.uploadImages = images;
    uploadModel.imageCompressRatio = compressRatio;
    uploadModel.mimeType = mimeType;
    uploadModel.requestIdentifer = requestIdentifer;
    uploadModel.uploadProgressBlock = progressBlock;
    uploadModel.uploadSuccessBlock = successBlock;
    uploadModel.uploadFailureBlock = failureBlock;
    
    [self p_sendUploadRequest:uploadModel];
    
}

#pragma mark - Private Methods

- (void)p_sendUploadRequest:(LENetworkRequestModel *)uploadModel  {
    
    __weak __typeof(self) weakSelf = self;
    NSURLSessionDataTask *uploadTask = [_sessionManager POST:uploadModel.requestUrl parameters:uploadModel.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [uploadModel.uploadImages enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            // 压缩率
            float ratio = uploadModel.imageCompressRatio;
            if (ratio > 1 || ratio < 0) {
                ratio = 1;
            }
            NSData *imageData = nil;
            NSString *imageType = uploadModel.mimeType.lowercaseString; // 转成小写
            
            if ([uploadModel.mimeType isEqualToString:@"png"]) {
                imageData = UIImagePNGRepresentation(image);
            } else {
                imageData = UIImageJPEGRepresentation(image, ratio);
            }
            
            long index = idx;
            NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
            long long totalMilliseconds = interval * 1000;
            // 文件名称
            NSString *fileName = [NSString stringWithFormat:@"%lld.%@", totalMilliseconds, imageType];
            NSString *identifer = [NSString stringWithFormat:@"%@%ld", uploadModel.imagesIdentifer, index];
            [formData appendPartWithFileData:imageData name:identifer fileName:fileName mimeType:[NSString stringWithFormat:@"image/%@", imageType]];
        }];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (uploadModel.uploadProgressBlock) {
                uploadModel.uploadProgressBlock(uploadProgress);
            }
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (uploadModel.uploadSuccessBlock) {
                uploadModel.uploadSuccessBlock(responseObject);
                [weakSelf handleRequesFinished:uploadModel];
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (uploadModel.uploadFailureBlock) {
                uploadModel.uploadFailureBlock(task, error, error.code, uploadModel.uploadImages);
                [weakSelf handleRequesFinished:uploadModel];
            }
        });
    }];
    uploadModel.task = uploadTask;
    
    [[LENetworkRequestPool sharePool] addRequestModel:uploadModel];
}
- (NSString *)p_completeRequestURLWithBaseURL:(NSString *)baseUrlStr requestURL:(NSString *)requestUrlStr {
    NSURL *requestUrl = [NSURL URLWithString:requestUrlStr];
    if (requestUrl && requestUrl.host && requestUrl.scheme) {
        return requestUrlStr;
    }
    NSURL *url = [NSURL URLWithString:baseUrlStr];
    
    if (baseUrlStr.length > 0 && ![baseUrlStr hasSuffix:@"/"]) {
        url = [url URLByAppendingPathComponent:@""];
    }
    return [NSURL URLWithString:requestUrlStr relativeToURL:url].absoluteString;
}
#pragma mark - Protocol

- (void)addCustomHeaders {
    NSDictionary *headers = [LENetworkConfig shareConfig].customHeaders;
    if (headers.allKeys.count > 0) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
            [self->_sessionManager.requestSerializer setValue:value forHTTPHeaderField:key];
        }];
    }
}
- (id)addDefaultParametersWithCustomParameters:(id)parameters {
    id temp_parameters = nil;
    if (parameters && [parameters isKindOfClass:[NSDictionary class]]) {
        if ([LENetworkConfig shareConfig].defaultParams.allKeys.count > 0) {
            NSMutableDictionary *temp = [[LENetworkConfig shareConfig].defaultParams mutableCopy];
            [temp addEntriesFromDictionary:parameters];
            temp_parameters = [temp copy];
        } else {
            temp_parameters = parameters;
        }
    } else {
        temp_parameters = [LENetworkConfig shareConfig].defaultParams;
    }
    return temp_parameters;
}
- (void)handleRequesFinished:(LENetworkRequestModel *)requestModel{
    
    //clear all blocks
    [requestModel clearAllBlocks];
    
    //remove this requst model from request queue
    [[LENetworkRequestPool sharePool] removeRequestModel:requestModel];
}


@end
