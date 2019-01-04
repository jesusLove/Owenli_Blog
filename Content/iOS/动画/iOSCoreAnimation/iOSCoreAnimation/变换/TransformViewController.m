//
//  TransformViewController.m
//  iOSCoreAnimation
//
//  Created by lqq on 2018/5/8.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "TransformViewController.h"

@interface TransformViewController ()
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UILabel *frameLB;
@end

@implementation TransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"仿射变换";
    self.view.backgroundColor = [UIColor whiteColor];
    self.animationView = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    self.animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animationView];
    

    self.frameLB = [[UILabel alloc] initWithFrame:CGRectMake(KSCREENWIDTH / 2 - 100, 300, 200, 30)];
    self.frameLB.text = [NSString stringWithFormat:@"(%.f %.f %.f %.f)",self.animationView.frame.origin.x, self.animationView.frame.origin.y, self.animationView.frame.size.width, self.animationView.frame.size.height];
    [self.view addSubview:self.frameLB];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

//    [self transformMPI4];
    [self transformMixture];
}


/**
 
 
 */
- (void)transformMPI4 {
    // 旋转 45°
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    // 使用图层的affineTransform属性。
    self.animationView.layer.affineTransform = transform;
//    self.animationView.transform = transform;
    self.frameLB.text = [NSString stringWithFormat:@"(%.f %.f %.f %.f)",self.animationView.frame.origin.x, self.animationView.frame.origin.y, self.animationView.frame.size.width, self.animationView.frame.size.height];
}
- (void)transformMixture {
    //创建一个新的transform
    CGAffineTransform transform = CGAffineTransformIdentity;
    // 移动200
    transform = CGAffineTransformTranslate(transform, 200, 0);
    // 缩小50%
    transform = CGAffineTransformScale(transform, 0.5, 0.5);
    // 旋转30°
    transform = CGAffineTransformRotate(transform, RADIANS_TO_DEGREES(30));
   
    // 注意动画顺序会影响变化的结果。
    
    self.animationView.layer.affineTransform = transform;
}

@end
