//
//  Book.m
//  YYModelCode
//
//  Created by lqq on 2017/12/21.
//  Copyright © 2017年 Elink. All rights reserved.
//

#import "Book.h"
#import "YYModel.h"
@implementation Book

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             
             @"name":@"n",
             @"page": @"p",
             @"desc": @"ext.desc",
             @"bookID": @[@"id", @"ID", @"book_id"]
             
             };
}

@end
