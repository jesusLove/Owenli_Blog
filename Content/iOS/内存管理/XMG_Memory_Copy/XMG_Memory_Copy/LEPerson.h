//
//  LEPerson.h
//  XMG_Memory_Copy
//
//  Created by lqq on 2018/9/27.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEPerson : NSObject <NSCopying>

@property(nonatomic, copy) NSArray *data;
//@property(nonatomic, retain) NSArray *data2;

@end
// 自定义Copy
