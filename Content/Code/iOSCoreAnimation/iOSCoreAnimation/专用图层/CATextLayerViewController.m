//
//  CATextLayerViewController.m
//  iOSCoreAnimation
//
//  Created by lqq on 2018/5/10.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "CATextLayerViewController.h"
#import <CoreText/CoreText.h>

@interface CATextLayerViewController ()
@property (nonatomic, strong) UIView *labelView;

@end

@implementation CATextLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.labelView = [[UIView alloc] initWithFrame:CGRectMake(50, 200, 300, 200)];
    self.labelView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.labelView];
    
    
//    [self createLabelView];
    
    [self richTextView];
}
// 使用CATextLayer图层显示文字
- (void)createLabelView {
    

    
    
    // 创建Text Layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.labelView.bounds;
    [self.labelView.layer addSublayer:textLayer];
    
    textLayer.foregroundColor = [UIColor blackColor].CGColor; //文本颜色
    textLayer.alignmentMode = kCAAlignmentJustified; // 对齐方式
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    // 设置 layer font
    CFStringRef fontName = (__bridge CFStringRef)(font.fontName);
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    // 渲染的分辨率
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    
    NSString *text = @"Lorem ipsum dolor sit amet asdf asdf asdf asdlfjlkasjdfljadsf asldf asldfj ";
    textLayer.string = text;
    
}

- (void)richTextView {
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.labelView.bounds;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.labelView.layer addSublayer:textLayer];
    
    // 设置 text attributes
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    UIFont *font = [UIFont systemFontOfSize:15];
    
    NSString *text = @"Lorem weqr ojasf asdflj pipoi qwlkjo nlklj";
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CTFontRef fontRef = CTFontCreateWithName(fontName, font.pointSize, nil);
    
    NSDictionary *attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor redColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef
                              };
    [string setAttributes:attribs range:NSMakeRange(0, [text length])];
    
    attribs = @{
                              (__bridge id)kCTForegroundColorAttributeName:(__bridge id)[UIColor blueColor].CGColor,
                              (__bridge id)kCTFontAttributeName:(__bridge id)fontRef,
                              (__bridge id)kCTUnderlineStyleAttributeName:@(kCTUnderlineStyleSingle),
                              };
    [string setAttributes:attribs range:NSMakeRange(6, 5)];
    
    CFRelease(fontRef);
    textLayer.string = string;
}


@end
