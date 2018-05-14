//
//  ViewController.m
//  DecorativePattern(装饰模式)
//
//  Created by lqq on 2018/5/12.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ViewController.h"
#import "ImageTransformFilter.h"

@interface ViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.image  = [UIImage imageNamed:@"p.jpg"];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 199, 100, 80)];
    [self.view addSubview:self.imageView];
    [self transformImage];
}

- (void)transformImage {
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_4);
    
    id <ImageComponent> finalImage = [[ImageTransformFilter alloc] initWithImageComponent:self.image transform:transform];
    self.imageView.image = finalImage;
}

@end
