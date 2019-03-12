//
//  LEView.m
//  OC语法规范
//
//  Created by LQQ on 2019/2/21.
//  Copyright © 2019 LQQ. All rights reserved.
//

#import "LEView.h"

@implementation LEView

// 扩大点击区域
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    CGRect touchRect = CGRectInset(self.bounds, -20, -20);
    if (CGRectContainsPoint(touchRect, point)) {
        for (UIView *subView in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subView convertPoint:point fromView:self];
            UIView *hitTestView = [subView hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
    }
    return nil;
}

@end
