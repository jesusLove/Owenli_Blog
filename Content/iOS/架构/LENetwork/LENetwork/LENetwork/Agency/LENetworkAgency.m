//
//  LENetworkAgency.m
//  LENetwork
//
//  Created by LQQ on 2018/12/29.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LENetworkAgency.h"
#import "LENetworkConfig.h"
#import "LENetworkRequestModel.h"
#import "LENetworkRequestPool.h"

@interface LENetworkAgency ()<LENetworkAgencyProtocol>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
@implementation LENetworkAgency

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
#pragma mark - # Public Method
- (void)sendRequest:(NSString *)url
             method:(LENetworkRequestMethod)method
         parameters:(id)parameters
            success:(LENetworkSuccessBlock)successBlock
            failure:(LENetworkFailureBlock)failureBlock {
    // 1. 拼接请求头
    [self addCustomHeaders]; // 添加自定义的Headers
    // 2. 拼接请求参数
    id tempParameters = [self addDefaultParametersWithCustomParameters:parameters];
    // 3. 转换请求方法
    NSString *methodStr = [self p_methodStringForRequestMethod:method];
    // 4. 完整请求路径
    NSString *completeUrl = [self p_completeRequestURLWithBaseURL:[LENetworkConfig shareConfig].baseUrl requestURL:url];
    
    // 5. 唯一标示
    NSString *identifer = url; // 暂时使用URL代替
    
    // 5. 发送请求, 参数处理完成
    [self p_sendRequest:completeUrl method:methodStr parameters:tempParameters  requestIdentifer:identifer success:successBlock failure:failureBlock];
}
#pragma mark - # Private Method
- (void)p_sendRequest:(NSString *)url
               method:(NSString * _Nonnull)method
           parameters:(id)parameters
     requestIdentifer:(NSString *)requestIdentifer
              success:(LENetworkSuccessBlock)successBlock
              failure:(LENetworkFailureBlock)failureBlock {
    
    LENetworkRequestModel *requestModel = [[LENetworkRequestModel alloc] init];
    requestModel.method = method;
    requestModel.requestUrl = url;
    requestModel.parameters = parameters;
    requestModel.requestIdentifer = requestIdentifer;
    requestModel.successBlock = successBlock;
    requestModel.failureBlock = failureBlock;
    
    
    NSError *error = nil;
    NSMutableURLRequest *request = [_sessionManager.requestSerializer requestWithMethod:method URLString:url parameters:parameters error:&error];
    
    __weak __typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [_sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf p_handleRequestModel:requestModel responseObject:responseObject error:error];
    }];
    
    requestModel.task = dataTask;
    
    // 添加到请求池
    [[LENetworkRequestPool sharePool] addRequestModel:requestModel];
    
    [dataTask resume];
}

- (void)p_handleRequestModel:(LENetworkRequestModel *)requestModel
              responseObject:(id)responseObject
                       error:(NSError *)error {
    NSError *requestError = nil;
    BOOL requestSuccessed = YES;
    if (error) {
        requestSuccessed = NO;
        requestError = error;
    }
    
    if (requestSuccessed) {
        // 请求成功
        requestModel.responseObject = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (requestModel.successBlock) {
                requestModel.successBlock(requestModel.responseObject);
            }
        });
    } else {
        // 请求失败
        dispatch_async(dispatch_get_main_queue(), ^{
            if (requestModel.failureBlock) {
                requestModel.failureBlock(requestModel.task, error, error.code);
            }
        });
    }
    // 请求完成
    dispatch_async(dispatch_get_main_queue(), ^{
        [requestModel clearAllBlocks];
        // 从请求池中移除
        [[LENetworkRequestPool sharePool] removeRequestModel:requestModel];
    });
}

- (NSString *)p_methodStringForRequestMethod:(LENetworkRequestMethod)method {
    switch (method) {
        case LENetworkRequestMethodGET:
            return @"GET";
            break;
        case LENetworkRequestMethodPOST:
            return @"POST";
            break;
        case LENetworkRequestMethodPUT:
            return @"PUT";
            break;
        case LENetworkRequestMethodDELETE:
            return @"DELETE";
            break;
    }
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

#pragma mark - # Protocol

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

@end
