//
//  ViewController.m
//  iOSTemplateAPP
//
//  Created by lqq on 2018/12/17.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LEKit/LEKit.h"
#import "LEActionSheet.h"

@interface ViewController ()<LEActionSheetDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    LEActionSheet *actionSheet = [[LEActionSheet alloc] initWithTitle:@"标题" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机", @"相册",@"其他", nil];
    [actionSheet show];
    
}

- (void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%ld", buttonIndex);
    NSLog(@"%@", [actionSheet buttonTitleAtIndex:buttonIndex]);
}
@end
