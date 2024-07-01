//
//  IndexTableView.m
//  TableView重用机制
//
//  Created by lqq on 2018/8/3.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "IndexTableView.h"
#import "ViewReusePool.h"

@interface IndexTableView() {
    UIView *containerView;
    ViewReusePool *resuePool;
}
@end

@implementation IndexTableView

- (void)reloadData {
    [super reloadData];
    
    // 懒加载
    if (containerView == nil) {
        containerView = [[UIView alloc] initWithFrame:CGRectZero];
        containerView.backgroundColor = [UIColor whiteColor];
        // 插入到TableView上方
        [self.superview insertSubview:containerView aboveSubview:self];
    }
    if (resuePool == nil) {
        resuePool = [[ViewReusePool alloc] init];
    }
    [resuePool reset];
    
    [self reloadIndexedBar];
}
- (void)reloadIndexedBar {
    NSArray <NSString *> *arrayTitles = nil;
    if ([self.indexedDataSource respondsToSelector:@selector(indexTitlesForIndexTableView:)]) {
        arrayTitles = [self.indexedDataSource indexTitlesForIndexTableView:self];
    }
    if (!arrayTitles || arrayTitles.count <= 0) {
        [containerView setHidden:YES];
        return;
    }
    NSUInteger count = arrayTitles.count;
    CGFloat buttonHeight = self.frame.size.height / count;
    
    for (int i = 0; i < arrayTitles.count; i ++) {
        NSString *title = arrayTitles[i];
        UIButton *button = (UIButton *)[resuePool dequeueReuseableView];
        if (button == nil) {
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor whiteColor];
            
            // 添加到重用池中
            [resuePool addUsingView:button];
            NSLog(@"创建一个BUTTON");
        } else {
            NSLog(@"BUTTON重用");
        }
        [containerView addSubview:button];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setFrame:CGRectMake(0, i * buttonHeight, self.indexWidth, buttonHeight)];
    }
    [containerView setHidden:NO];
    containerView.frame = CGRectMake(self.frame.origin.x + self.frame.size.width - self.indexWidth, self.frame.origin.y + self.indexWidth, self.indexWidth, self.frame.size.height);
}


@end
