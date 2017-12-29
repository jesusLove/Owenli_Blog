//
//  User.h
//  YYModelCode
//
//  Created by lqq on 2017/12/21.
//  Copyright © 2017年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface User : NSObject<NSCopying, NSCoding>
@property UInt64 uid;
@property NSString *name;
@property NSDate *created;
@end
