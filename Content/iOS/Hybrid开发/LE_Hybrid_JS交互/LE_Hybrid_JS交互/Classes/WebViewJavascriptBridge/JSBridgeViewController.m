//
//  JSBridgeViewController.m
//  LE_Hybrid_JS交互
//
//  Created by lqq on 2018/10/26.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "JSBridgeViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge.h>

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
@interface JSBridgeViewController () <WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@end

@implementation JSBridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jsbridge" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    // 设置代理
    [self.bridge setWebViewDelegate:self];
    
    [self registerFunctions];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OCToJS" style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
}
- (void)rightAction:(UIBarButtonItem *)item {
    [self.bridge callHandler:@"leJSFunction" data:@"我是OC发来数据" responseCallback:^(id responseData) {
        NSLog(@"我是JS回调数据：%@", responseData);
    }];
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)registerFunctions {
    [self registLocationFunction];
    [self registScanFunction];
    [self registShareFunction];
    [self registPayFunction];
    [self registColorFunction];
}
- (void)registLocationFunction
{
    [self.bridge registerHandler:@"locationClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // 获取位置信息
        
        NSString *location = @"山东青岛";
        // 将结果返回给js
        responseCallback(location);
    }];
}
- (void)registShareFunction {
    [self.bridge registerHandler:@"shareClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *result = data;
        NSString *title = [result objectForKey:@"title"];
        NSString *content = [result objectForKey:@"content"];
        NSString *url = [result objectForKey:@"url"];
        NSString *shareContent = [NSString stringWithFormat:@"分享成功：%@ %@ %@", title, content, url];
        
        responseCallback(shareContent);
    }];
}
- (void)registPayFunction {
    [self.bridge registerHandler:@"payClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        // data 的类型与 JS中传的参数有关
        NSDictionary *tempDic = data;
        
        NSString *orderNo = [tempDic objectForKey:@"order_no"];
        NSString *subject = [tempDic objectForKey:@"subject"];
        NSString *channel = [tempDic objectForKey:@"channel"];
        // 支付操作...
        
        // 将分享的结果返回到JS中
        NSString *result = [NSString stringWithFormat:@"支付成功:%@,%@,%@",orderNo,subject,channel];
        responseCallback(result);
    }];
}
- (void)registScanFunction
{
    // 注册的handler 是供 JS调用Native 使用的。
    [self.bridge registerHandler:@"scanClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"扫一扫");
        NSString *scanResult = @"http://www.baidu.com";
        responseCallback(scanResult);
    }];
}
- (void)registColorFunction {
     __weak typeof(self) weakSelf = self;
    [self.bridge registerHandler:@"colorClick" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"修改颜色");
        NSDictionary *tempDic = data;
        
        CGFloat r = [[tempDic objectForKey:@"r"] floatValue];
        CGFloat g = [[tempDic objectForKey:@"g"] floatValue];
        CGFloat b = [[tempDic objectForKey:@"b"] floatValue];
        CGFloat a = [[tempDic objectForKey:@"a"] floatValue];
        
        weakSelf.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
    }];
}

@end
