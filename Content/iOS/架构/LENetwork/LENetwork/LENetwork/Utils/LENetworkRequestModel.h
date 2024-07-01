//
//  LENetworkRequestModel.h
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LENetworkHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LENetworkRequestModel : NSObject

@property(nonatomic, copy) NSString *requestIdentifer; // 唯一标示

@property (nonatomic, strong) NSURLSessionTask *task; // 请求Task

@property (nonatomic, strong) NSURLResponse *response; // NSHTTPURLRespnose 对象

@property(nonatomic, copy) NSString *requestUrl; // 请求地址

@property(nonatomic, copy) NSString *method;

@property (nonatomic, strong) id responseObject;

// GET POST 等请求 <-------- 独有的属性

@property (nonatomic, strong) id  parameters;
@property (nonatomic, strong) NSData *responseData;

@property(nonatomic, copy) LENetworkSuccessBlock successBlock;
@property(nonatomic, copy) LENetworkFailureBlock failureBlock;


// Upload 独有的属性

@property(nonatomic, copy) NSString *uploadUrl;
@property(nonatomic, copy) NSArray<UIImage *> *uploadImages;
@property(nonatomic, copy) NSString *imagesIdentifer;
@property(nonatomic, copy) NSString *mimeType;
@property (nonatomic, assign) float imageCompressRatio;
@property(nonatomic, copy) LEUploadProgressBlock uploadProgressBlock;
@property(nonatomic, copy) LEUploadSuccessBlock uploadSuccessBlock;
@property(nonatomic, copy) LEUploadFailureBlock uploadFailureBlock;


- (void)clearAllBlocks;

@end

NS_ASSUME_NONNULL_END
