//
//  LENetworkDownloadAgency.m
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import "LENetworkDownloadAgency.h"
#import "LENetworkConfig.h"

@interface LENetworkDownloadAgency ()<LENetworkAgencyProtocol>

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end
@implementation LENetworkDownloadAgency
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
@end
