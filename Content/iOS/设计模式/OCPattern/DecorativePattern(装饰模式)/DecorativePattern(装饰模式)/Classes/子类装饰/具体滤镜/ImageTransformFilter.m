//
//  ImageTransformFilter.m
//  DecorativePattern(装饰模式)
//
//  Created by lqq on 2018/5/12.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ImageTransformFilter.h"

@implementation ImageTransformFilter

- (instancetype)initWithImageComponent:(id<ImageComponent>)component transform:(CGAffineTransform)transform {
    if (self = [super initWithImageComponent:component]) {
        self.transform = transform;
    }
    return self;
}
- (void)apply {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, self.transform);
}
@end
