//
//  LEADButton.m
//  DispatchSourceDemo
//
//  Created by LQQ on 2019/1/4.
//  Copyright © 2019 Elink. All rights reserved.
//

#import "LEADButton.h"
#define BGCOLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
@interface LEADButton ()
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) CAShapeLayer *roundLayer; //
@property(nonatomic, copy) dispatch_source_t roundTimer; // 一个定时器源
@end
@implementation LEADButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.timeLB];
        [self.timeLB.layer addSublayer:self.roundLayer];
    }
    return self;
}

#pragma mark - # Public Methods
- (void)startRoundDispathTimerWithDuration:(CGFloat)duration {
    self.roundLayer.strokeStart = 0;
    // 时间间隔
    NSTimeInterval period = 0.05;
    __block CGFloat roundDuration = duration;
    // 创建一个定时源
    _roundTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_roundTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    // 指定需要执行的任务
    dispatch_source_set_event_handler(_roundTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (roundDuration <= 0) {
                self.roundLayer.strokeStart = 1;
                // 处理结束
                dispatch_source_cancel(self.roundTimer);
                self.roundTimer = nil;
            }
            self.roundLayer.strokeStart += 1 / (duration / period);
            roundDuration -= period;
        });
    });
    // 启动Source
    dispatch_resume(_roundTimer);
}


#pragma mark - # Getter

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] initWithFrame:self.bounds];
        _timeLB.textColor = [UIColor whiteColor];
        _timeLB.backgroundColor = BGCOLOR;
        _timeLB.layer.masksToBounds = YES;
        _timeLB.text = @"跳过";
        _timeLB.textAlignment = NSTextAlignmentCenter;
        _timeLB.font = [UIFont systemFontOfSize:13.5];
        CGFloat min = _timeLB.frame.size.height;
        if (min > _timeLB.frame.size.width) {
            min = _timeLB.frame.size.width;
        }
        _timeLB.layer.cornerRadius = min / 2.0;
        _timeLB.layer.masksToBounds = YES;
    }
    return _timeLB;
}

- (CAShapeLayer *)roundLayer {
    if (!_roundLayer) {
        _roundLayer = [CAShapeLayer layer];
        _roundLayer.fillColor = BGCOLOR.CGColor;
        _roundLayer.strokeColor = [UIColor whiteColor].CGColor;
        _roundLayer.lineCap = kCALineCapRound;
        _roundLayer.lineJoin = kCALineJoinRound;
        _roundLayer.lineWidth = 2;
        _roundLayer.frame = self.bounds;
        _roundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.timeLB.frame.size.width / 2.0, self.timeLB.frame.size.width / 2.0) radius:self.timeLB.frame.size.width / 2.0 - 1.0 startAngle:-0.5 * M_PI endAngle:1.5 * M_PI clockwise:YES].CGPath;
        _roundLayer.strokeStart = 0;
    }
    return _roundLayer;
}

@end
