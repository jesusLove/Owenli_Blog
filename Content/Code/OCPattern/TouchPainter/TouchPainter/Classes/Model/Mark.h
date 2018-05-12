//
//  Mark.h
//  TouchPainter
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol Mark <NSObject>

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) CGSize *size;
@property (nonatomic, strong) CGPoint *location;

- (void)addMark:(id <Mark>)mark;

@end
