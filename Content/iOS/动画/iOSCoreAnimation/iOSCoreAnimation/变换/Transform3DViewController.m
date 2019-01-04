//
//  Transform3DViewController.m
//  iOSCoreAnimation
//
//  Created by lqq on 2018/5/9.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "Transform3DViewController.h"

@interface Transform3DViewController ()
@property (nonatomic, strong) UIImageView *animationView;
@end

@implementation Transform3DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.animationView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 200, 150)];
    self.animationView.image = [UIImage imageNamed:@"work.jpg"];
    self.animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animationView];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self transform3D];
//    [self transformPerspective];
    
    [self dobleSide];
}

- (void)transform3D {
    CATransform3D transform = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    self.animationView.layer.transform = transform;
}

- (void)transformPerspective {
    // 创建一个transform
    CATransform3D transform = CATransform3DIdentity;
    // 在3D透视效果中，m34用于按比例缩放X和Y的值来计算到底要离视角多远。
    // 500 代表视角相机和屏幕之间的距离，单位像素。
    transform.m34 = -1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    self.animationView.layer.transform = transform;
}

- (void)sublayerTransfrom {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = - 1.0 / 500;
    self.animationView.layer.sublayerTransform = transform;
    // 此时会影响self.animationView 中的所有子图层。
}

- (void)dobleSide {
    // 创建一个transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 500.0;
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    self.animationView.layer.transform = transform;
    // 此时会发现图层是正面的一个镜像图片。
    
    // 因为图层是双面绘制的
    
    // CALayer有一个属性doubleSided属性控制图层是否双面绘制。默认是YES
    self.animationView.layer.doubleSided = NO;
}

@end
