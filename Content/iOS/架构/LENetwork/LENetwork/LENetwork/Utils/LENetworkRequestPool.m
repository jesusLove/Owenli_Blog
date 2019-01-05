//
//  LENetworkRequestPool.m
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import "LENetworkRequestPool.h"
#import "LENetworkRequestModel.h"
#import <objc/runtime.h>
#import <pthread/pthread.h>

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

static char currentRequestModelsKey;
@implementation LENetworkRequestPool{
    pthread_mutex_t _lock;
}

+ (LENetworkRequestPool *)sharePool {
    static LENetworkRequestPool *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LENetworkRequestPool alloc] init];
    });
    return manager;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL); // 初始化锁
    }
    return self;
}

- (NSMutableDictionary<NSString *,LENetworkRequestModel *> *)currentRequestModels {
    NSMutableDictionary<NSString *,LENetworkRequestModel *> *currentTasks = objc_getAssociatedObject(self, &currentRequestModelsKey);
    if (currentTasks) {
        return currentTasks;
    }
    currentTasks = [NSMutableDictionary dictionary];
    objc_setAssociatedObject(self, &currentRequestModelsKey, currentTasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return currentTasks;
}
- (void)addRequestModel:(LENetworkRequestModel *)requestModel {
    Lock();
    [self.currentRequestModels setObject:requestModel forKey:[NSString stringWithFormat:@"%ld", (unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
}
- (void)removeRequestModel:(LENetworkRequestModel *)requestModel {
    Lock();
    [self.currentRequestModels removeObjectForKey:[NSString stringWithFormat:@"%ld", (unsigned long)requestModel.task.taskIdentifier]];
    Unlock();
}
- (BOOL)remainingCurrentRequests {
    NSArray *keys = [self.currentRequestModels allKeys];
    if (keys.count > 0) {
        return YES;
    } else {
        return NO;
    }
}
- (NSInteger)currentRequestCount {
    if (![self remainingCurrentRequests]) {
        return 0;
    }
    return self.currentRequestModels.allKeys.count;
}

// 取消所有请求
- (void)cancelAllCurrentRequests {
    
    if ([self remainingCurrentRequests]) {
        for (LENetworkRequestModel *requestModel in [self.currentRequestModels allValues]) {
            NSLog(@"cancelRequest: %@ \n", requestModel.requestUrl);
            // 取消任务
            [requestModel.task cancel];
            // 移除Model
            [self removeRequestModel:requestModel];
        }
    }
}

// 取消URL的请求
- (void)cancelCurrentRequestWithUrl:(NSString *)url {
    if (![self remainingCurrentRequests]) {
        return;
    }
    [self.currentRequestModels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, LENetworkRequestModel * _Nonnull requestModel, BOOL * _Nonnull stop) {
        if ([requestModel.requestUrl containsString:url]) {
            NSLog(@"cancelRequest: %@ \n", requestModel.requestUrl);
            [requestModel.task cancel];
            [self removeRequestModel:requestModel];
        }
    }];
}

@end
