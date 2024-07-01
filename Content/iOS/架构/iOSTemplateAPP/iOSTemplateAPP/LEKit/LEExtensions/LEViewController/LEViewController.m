//
//  LEViewController.m
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/21.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LEViewController.h"
#import <UMMobClick/MobClick.h>

@interface LEViewController ()

@end

@implementation LEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 打点分析
    
    [MobClick beginLogPageView:self.analyzeTitle];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 结束分析
    [MobClick endLogPageView:self.analyzeTitle];
}

- (void)dealloc {
#ifdef DEBUG_MEMERY
    NSLog(@"dealloc %@", self.navigationItem.title);
#endif
}

#pragma mark - Getter
- (NSString *)analyzeTitle {
    if (_analyzeTitle == nil) {
        return self.navigationItem.title;
    }
    return _analyzeTitle;
}

@end
