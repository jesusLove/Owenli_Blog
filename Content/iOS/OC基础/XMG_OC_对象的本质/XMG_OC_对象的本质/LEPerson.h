//
//  LEPerson.h
//  XMG_OC_对象的本质
//
//  Created by lqq on 2018/9/21.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LEPerson : NSObject

@property (nonatomic, assign) int  age; // 一个int占用4个字节，由于内存对其原因，系统分配16字节内存，对象占用16字节

@property (nonatomic, assign) int tall; // 在添加一个int，对象占用的还是16字节。

@property (nonatomic, assign) int sex;

@property (nonatomic, strong) NSObject *object;

// 对象真正占用的空间大小是按照8的倍数使用的。

// 系统在分配内存时，分配的大小是按照16的倍数进行分配的。
@end
