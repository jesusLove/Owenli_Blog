//
//  ImageTransformFilter.h
//  DecorativePattern(装饰模式)
//
//  Created by lqq on 2018/5/12.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ImageFilter.h"

@interface ImageTransformFilter : ImageFilter

@property(nonatomic, assign) CGAffineTransform transform;

- (instancetype)initWithImageComponent:(id<ImageComponent>)component transform:(CGAffineTransform)transform;

- (void)apply;
@end
