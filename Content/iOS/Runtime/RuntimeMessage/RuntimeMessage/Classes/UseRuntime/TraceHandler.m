//
//  TraceHandler.m
//  RuntimeMessage
//
//  Created by lqq on 2018/4/28.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "TraceHandler.h"

@implementation TraceHandler

+ (void)traceStatusWithName:(NSString *)className {
    NSLog(@"TraceHandler - %@", className);
}
@end
