//
//  FindCommonSuperView.m
//  Algorithm
//
//  Created by lqq on 2018/9/14.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "FindCommonSuperView.h"

@implementation FindCommonSuperView
- (NSArray<NSView *> *)findCommonSuperView:(NSView *)view other:(NSView *)viewOther {
    // 结果数组
    NSMutableArray *result = [NSMutableArray array];
    // 两个子视图所有父视图组成的数组。
    NSArray *aSuperViews = [self findSuperView:view];
    NSArray *bSuperViews = [self findSuperView:viewOther];
    int i = 0;
    // 越界条件选取小的那个
    while (i < MIN(aSuperViews.count, bSuperViews.count)) {
        NSView *aSuperView = [aSuperViews objectAtIndex:aSuperViews.count - i - 1];
        NSView *bSuperView = [bSuperViews objectAtIndex:bSuperViews.count - i - 1];
        // 比较是否相等，相等则为共同父视图。不相等结束遍历。
        if (aSuperView == bSuperView) {
            [result addObject:aSuperView];
            i++;
        } else {
            break;
        }
    }
    return result;
}
- (NSArray <NSView *> *)findSuperView:(NSView *)view {
    // 第一个父视图
    NSView *temp = view.superview;
    NSMutableArray *result = [NSMutableArray array];
    while (temp) {
        [result addObject:temp];
        temp = temp.superview;
    }
    return result;
}
@end
