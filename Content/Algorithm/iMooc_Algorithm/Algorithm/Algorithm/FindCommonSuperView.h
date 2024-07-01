//
//  FindCommonSuperView.h
//  Algorithm
//
//  Created by lqq on 2018/9/14.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface FindCommonSuperView : NSObject

/**
 查找两个视图的共同父视图

 @param view 视图A
 @param viewOther 视图B
 @return 共同父视图数组
 */
- (NSArray <NSView *> *)findCommonSuperView:(NSView *)view other:(NSView *)viewOther;

@end
