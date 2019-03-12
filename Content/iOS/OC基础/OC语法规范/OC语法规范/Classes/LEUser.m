//
//  LEUser.m
//  OC语法规范
//
//  Created by LQQ on 2019/2/20.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import "LEUser.h"
// enum 建议使用 NS_ENUM 和 NS_OPTIONS 宏来定义枚举类型。
typedef NS_ENUM(NSUInteger, LEUserGender) {
    LEUserGenderMale,
    LEUserGenderFemale,
    LEUserGenderNeutral
};
@interface LEUser ()

@property (nonatomic, assign) NSUInteger age;

@end

@implementation LEUser



@end
