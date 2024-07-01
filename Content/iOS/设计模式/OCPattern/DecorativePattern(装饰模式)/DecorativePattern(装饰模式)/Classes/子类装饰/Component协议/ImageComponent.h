//
//  ImageComponent.h
//  DecorativePattern(装饰模式)
//
//  Created by lqq on 2018/5/12.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    让ImageComponent支持一下操作，但是实际上我们并没有实现他们。知识为了跟UIImage中的方法对应，从而捕获他们。
 */
@protocol ImageComponent <NSObject>

@optional

- (void)drawAtPoint:(CGPoint)point;                                                        // mode = kCGBlendModeNormal, alpha = 1.0
- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)drawInRect:(CGRect)rect;                                                           // mode = kCGBlendModeNormal, alpha = 1.0
- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;

- (void)drawAsPatternInRect:(CGRect)rect; // draws the image as a CGPattern

@end



