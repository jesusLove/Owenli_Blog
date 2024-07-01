//
//  HookViewController.m
//  LE_Hybrid_JS交互
//
//  Created by lqq on 2018/10/26.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "HookViewController.h"
#import <WebKit/WebKit.h>

#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
@interface HookViewController () <WKNavigationDelegate, WKUIDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"拦截跳转";
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"hook" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - WKNavigationDelegate


- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = url.scheme;
    if ([scheme isEqualToString:@"elink"]) {
        [self handleURL: url];
        decisionHandler(WKNavigationActionPolicyCancel); // 不允许跳转
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow); // 允许跳转
}


#pragma mark - WKUIDelegate
// 如果想在`WKWebView`中显示alert，需要实现该协议方法
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    NSLog(@"%@", message);

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];

    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 处理不同URL Scheme
- (void)handleURL:(NSURL *)url {
    NSLog(@"%@", url.host);
    if ([url.host isEqualToString:@"scan"]) {
        [self scanQR:url];
    } else if ([url.host isEqualToString:@"location"]) {
        [self locationInfo:url];
    }
}
// 扫描
- (void)scanQR:(NSURL *)url {
    NSArray *params = [url.query componentsSeparatedByString:@"&"];
    NSMutableDictionary *tempParams = [NSMutableDictionary dictionary];
    for (NSString *item in params) {
        NSArray *temp = [item componentsSeparatedByString:@"="];
        if (temp.count != 0) {
            [tempParams setObject:temp.lastObject forKey:temp.firstObject];
        }
    }
    NSLog(@"%@", tempParams);
}
// 获取定位，并返回定位结果
- (void)locationInfo:(NSURL *)url {
    // 获取地理位置
    NSString *info = [NSString stringWithFormat:@"setLocation('%@')", @"山东省青岛市市北区"];
    // 将获取到的值返回给JS
    [self.webView evaluateJavaScript:info completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"%@ - %@", result, error);
    }];
}


#pragma mark - 懒加载
- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}
@end
