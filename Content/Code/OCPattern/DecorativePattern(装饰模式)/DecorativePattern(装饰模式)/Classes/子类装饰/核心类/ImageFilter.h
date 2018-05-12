//
//  ImageFilter.h
//  DecorativePattern(装饰模式)
//
//  Created by lqq on 2018/5/12.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+ImageComponent.h"

@interface ImageFilter : NSObject <ImageComponent>

/**
 一个ImageComponent引用，被其他装饰器装饰。
 */
@property(nonatomic, assign) id <ImageComponent> component;

/**
 用来被子类继承
 */
- (void)apply;
/**
 初始化方法
 */
- (instancetype)initWithImageComponent:(id <ImageComponent>)component;
/**
 重载NSObject中的方法，用来截获`draw`开头的方法
 */
- (id)forwardingTargetForSelector:(SEL)aSelector;
@end
