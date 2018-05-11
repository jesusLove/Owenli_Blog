//
//  CAShapeLayerViewController.m
//  iOSCoreAnimation
//
//  Created by lqq on 2018/5/10.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "CAShapeLayerViewController.h"

@interface CAShapeLayerViewController ()

@end

@implementation CAShapeLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self shapeLayerView];
    [self cornerRadiusOfShapeLayer];
}

- (void)shapeLayerView {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(175, 200)];
    // 头部
    [path addArcWithCenter:CGPointMake(150, 200) radius:25 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    // 身体和脚
    [path moveToPoint:CGPointMake(150, 225)];
    [path addLineToPoint:CGPointMake(150, 275)];
    [path addLineToPoint:CGPointMake(125, 325)];
    [path moveToPoint:CGPointMake(150, 275)];
    [path addLineToPoint:CGPointMake(175, 325)];
    // 手
    [path moveToPoint:CGPointMake(100, 250)];
    [path addLineToPoint:CGPointMake(200, 250)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5; //线宽
    shapeLayer.lineJoin = kCALineJoinRound; // 结点样子
    shapeLayer.lineCap = kCALineCapRound; // 线条结尾样子
    shapeLayer.path = path.CGPath;
    [self.view.layer addSublayer:shapeLayer];
}


/**
 为矩形指定圆角
 */
- (void)cornerRadiusOfShapeLayer {
    // 视图
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(100, 400, 200, 150)];
    containView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:containView];
    // 圆角大小
    CGSize radii = CGSizeMake(20, 20);
    // 哪个角
    //    UIRectCornerTopLeft     = 1 << 0,
    //    UIRectCornerTopRight    = 1 << 1,
    //    UIRectCornerBottomLeft  = 1 << 2,
    //    UIRectCornerBottomRight = 1 << 3,
    //    UIRectCornerAllCorners  = ~0UL
    UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    // path
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:containView.bounds byRoundingCorners:corners cornerRadii:radii];
    // 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    // mask 属性
    containView.layer.mask = shapeLayer;
    
}
@end


@interface UIView (RoundedCorners)

/**
 单独设置矩形圆角

 @param corners 哪个角
 @param radius 圆角大小
 */
-(void)lq_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end
@implementation UIView (RoundedCorners)

-(void)lq_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}
@end




