//
//  LENetworkRequestModel.m
//  LENetwork
//
//  Created by LQQ on 2019/1/3.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import "LENetworkRequestModel.h"

@implementation LENetworkRequestModel
- (void)clearAllBlocks {
    _successBlock = nil;
    _failureBlock = nil;
    
    _uploadFailureBlock = nil;
    _uploadSuccessBlock = nil;
    _uploadFailureBlock = nil;
}
@end
