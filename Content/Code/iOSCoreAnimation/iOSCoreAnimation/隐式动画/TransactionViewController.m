//
//  TransactionViewController.m
//  iOSCoreAnimation
//
//  Created by lqq on 2018/5/11.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "TransactionViewController.h"

@interface TransactionViewController ()
@property (weak, nonatomic) IBOutlet UIView *layerView;
@property (nonatomic, strong) CALayer *colorLayer;

@end

@implementation TransactionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
//    [self actionForLayer];
    [self createColorLayer];
    [self customTransition];
}

- (void)createColorLayer {
    self.layerView.backgroundColor = [UIColor redColor];
    self.colorLayer = [CALayer layer];
    self.colorLayer.frame = self.layerView.bounds;
    self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.layerView.layer addSublayer:self.colorLayer];
}
#pragma mark - 自定义行为
- (void)customTransition {
    // 添加自定义的action
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    self.colorLayer.actions = @{@"backgroundColor": transition};
}

- (IBAction)changeButtonAction:(id)sender {
    
#pragma mark - 事务
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;

// 加入事务
//    // 开始一个新的事务
//    [CATransaction begin];
//    // 修改执行时间
//    [CATransaction setAnimationDuration:1];
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
//    // 提交事务
//    [CATransaction commit];
    
    // 该方法内部自动调用，CATransaction的+begin和+commit方法。避免遗漏造成的风险。
//    [UIView animateWithDuration:1 animations:^{
//        CGFloat red = arc4random() / (CGFloat)INT_MAX;
//        CGFloat green = arc4random() / (CGFloat)INT_MAX;
//        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
//    }];
    
#pragma mark - 完成快
    
//    [CATransaction begin];
//
//    [CATransaction setAnimationDuration:1];
//
//    // 事务完成后执行
//    [CATransaction setCompletionBlock:^{
//        // 执行时间0.25秒
//        CGAffineTransform transform = self.colorLayer.affineTransform;
//        transform = CGAffineTransformRotate(transform, M_PI_2);
//        self.colorLayer.affineTransform = transform;
//    }];
//
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
//
//    [CATransaction commit];
    
#pragma mark - 图层行为
    // 此时，并没有过渡效果，因为UIView图层将隐式动画功能禁用了。
//    [CATransaction begin];
//
//    [CATransaction setAnimationDuration:1];
//
//    CGFloat red = arc4random() / (CGFloat)INT_MAX;
//    CGFloat green = arc4random() / (CGFloat)INT_MAX;
//    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
//    self.layerView.layer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
//    [CATransaction commit];
}

#pragma mark - 测试actionForLayer:forKey的实现

- (void)actionForLayer {
    NSLog(@"Outside: %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    
    [UIView beginAnimations:nil context:nil];
    
    NSLog(@"Inside : %@", [self.layerView actionForLayer:self.layerView.layer forKey:@"backgroundColor"]);
    
    [UIView commitAnimations];
    
    /*
     输出：
     2018-05-11 10:15:25.340843+0800 iOSCoreAnimation[62679:4843422] Outside: <null>
     2018-05-11 10:15:25.342467+0800 iOSCoreAnimation[62679:4843422] Inside : <CABasicAnimation: 0x60000042c760>
     */
}

























@end
