//
//  JSCoreViewController.m
//  LE_Hybrid_JS交互
//
//  Created by lqq on 2018/10/26.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "JSCoreViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENH [UIScreen mainScreen].bounds.size.height
@interface JSCoreViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) JSContext *context;
@end

@implementation JSCoreViewController


#pragma mark - JavascriptCore 简介

- (void)jsCoreDemo {
    // 创建运行环境
    JSContext *context = [[JSContext alloc] init];
    
    JSValue *jsValue = [context evaluateScript:@"2 * 3"];
    
    NSLog(@"JSValue: %@, int : %d", jsValue, [jsValue toInt32]);
    
    // 直接使用下标获取
    [context evaluateScript:@"var arr = ['a', 'b', 'c']"];
    JSValue *jsArr = context[@"arr"];
    
    NSLog(@"%@ , %@", jsArr, [jsArr toArray]);
}



#pragma mark - ========================

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JavascriptCore";
    [self.view addSubview:self.webView];

    // UIWebView中获取JSContext
    self.context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
}
#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
#pragma mark - 懒加载
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENW, SCREENH)];
        _webView.delegate = self;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"jscore" ofType:@"html"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    return _webView;
}
@end
