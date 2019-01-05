//
//  ViewController.m
//  LENetwork
//
//  Created by LQQ on 2018/12/27.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "LENetworkManager.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LENetworkConfig shareConfig].baseUrl = @"https://eug.elinkit.com.cn";

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [LENetworkConfig shareConfig].defaultParams = @{@"latitude": @"36.08743", @"longitude":@"120.37479"};
    [[LENetworkManager shareManager] POST:@"/eug/app/v1/map/markers" parameters:nil success:^(id responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionTask *task, NSError *error, NSInteger statusCode) {
        
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[LENetworkManager shareManager] cancelCurrentRequest:@"/eug/app/v1/map/markers"];
}
@end
