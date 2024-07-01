//
//  LEActionSheet.m
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/19.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LEActionSheet.h"

#define     TITLE_FONT_SIZE             13.0f
#define     BUTTON_FONT_SIZE            18.0f
#define     HEIGHT_BUTTON               48.0f
#define     SPACE_MIDDEL                8.0f
#define     SPACE_TITLE_LEFT            22.0f
#define     SPACE_TITLE_TOP             20.0f

#define     COLOR_BACKGROUND            [UIColor colorWithWhite:0.0 alpha:0.4] // 蒙版颜色
#define     COLOR_DESTRUCTIVE_TITLE     [UIColor redColor] // 特殊Title
#define     COLOR_TABLEVIEW_BG          [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0] // TableView背景色
#define     COLOR_SEPERATOR             [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0] // 分割线颜色

#define IS_IPHONEX          ([UIScreen mainScreen].bounds.size.width >= 375.0f && [UIScreen mainScreen].bounds.size.height >= 812.0f)
#define HOME_INDICATOR_HEIGHT  (IS_IPHONEX ? 34.f : 0)

@interface LEActionSheet () <UITableViewDelegate, UITableViewDataSource>
{
    NSInteger tableViewButtonCount; // 按键个数
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *cancelButtonTitle;
@property (nonatomic, strong) NSString *destructiveButtonTitle;
@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@property (nonatomic, strong) UIButton *backgroundView; // 蒙版
@property (nonatomic, strong) UIView *actionSheectView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *headerTitleLabel;

@end
@implementation LEActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<LEActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        self.delegate = delegate;
        self.title = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;
        
        va_list list;
        if (otherButtonTitles) {
            self.otherButtonTitles = [[NSMutableArray alloc] initWithCapacity:0];
            [self.otherButtonTitles addObject:otherButtonTitles];
            
            va_start(list, otherButtonTitles);
            NSString *otherTitle = va_arg(list, id);
            while (otherTitle) {
                [self.otherButtonTitles addObject:otherTitle];
                otherTitle = va_arg(list, id);
            }
        }
        
        tableViewButtonCount = self.otherButtonTitles.count + (destructiveButtonTitle ? 1 : 0);
        _numberOfButtons = tableViewButtonCount + (cancelButtonTitle ? 1 : 0);
        _destructiveButtonIndex = (destructiveButtonTitle ? 0 : -1);
        _cancelButtonIndex = (self.cancelButtonTitle ? self.otherButtonTitles.count + (self.destructiveButtonTitle ? 1 : 0) : -1);
        
        [self p_initSubViews];
    }
    return self;
}
- (instancetype)initWithTitle:(NSString *)title
                  clickAction:(void (^)(NSInteger buttonIndex))clickAction
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
       destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        self.clickAction = clickAction;
        self.title = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.destructiveButtonTitle = destructiveButtonTitle;
        
        va_list list;
        if (otherButtonTitles) {
            self.otherButtonTitles = [[NSMutableArray alloc] initWithCapacity:0];
            [self.otherButtonTitles addObject:otherButtonTitles];
            
            va_start(list, otherButtonTitles);
            NSString *otherTitle = va_arg(list, id);
            while (otherTitle) {
                [self.otherButtonTitles addObject:otherTitle];
                otherTitle = va_arg(list, id);
            }
        }
        
        tableViewButtonCount = self.otherButtonTitles.count + (destructiveButtonTitle ? 1 : 0);
        _numberOfButtons = tableViewButtonCount + (cancelButtonTitle ? 1 : 0);
        _destructiveButtonIndex = (destructiveButtonTitle ? 0 : -1);
        _cancelButtonIndex = (self.cancelButtonTitle ? self.otherButtonTitles.count + (self.destructiveButtonTitle ? 1 : 0) : -1);
        
        [self p_initSubViews];
    }
    return self;
}

#pragma mark - Publick Methods
- (void)show {
    [self showInView:[UIApplication sharedApplication].delegate.window];
}
- (void)showInView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    [view addSubview:self];
    CGRect rect = CGRectMake(0, self.frame.size.height - self.actionSheectView.frame.size.height, self.frame.size.width, self.actionSheectView.frame.size.height);
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.actionSheectView.frame = CGRectMake(0, self.frame.size.height, self.actionSheectView.frame.size.width, self.actionSheectView.frame.size.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.actionSheectView.frame = rect;
        self.backgroundView.backgroundColor = COLOR_BACKGROUND;
    }];
}
- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex {
    buttonIndex -= self.destructiveButtonTitle ? 1 : 0;
    if (buttonIndex == -1) {
        return self.destructiveButtonTitle;
    } else if (buttonIndex >= 0 && buttonIndex < self.otherButtonTitles.count) {
        return self.otherButtonTitles[buttonIndex];
    } else if (buttonIndex == self.otherButtonTitles.count) {
        return self.cancelButtonTitle;
    }
    return nil;
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableViewButtonCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LEActionSheetCell" forIndexPath:indexPath];
    [cell.textLabel setFont:[UIFont systemFontOfSize:BUTTON_FONT_SIZE]];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    if (self.destructiveButtonTitle) {
        if (indexPath.row == 0) {
            [cell.textLabel setTextColor:COLOR_DESTRUCTIVE_TITLE];
            [cell.textLabel setText:self.destructiveButtonTitle];
        } else {
            [cell.textLabel setTextColor:[UIColor blackColor]];
            [cell.textLabel setText:self.otherButtonTitles[indexPath.row -1]];
        }
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
        [cell.textLabel setText:self.otherButtonTitles[indexPath.row]];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.clickAction) {
        self.clickAction(indexPath.row);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissWithClickedButtonIndex:indexPath.row animated:YES];
}

#pragma mark - Private Method
- (void)p_initSubViews {
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.backgroundView];
    [self addSubview:self.actionSheectView];
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
    [self.actionSheectView addSubview:self.tableView];
    self.backgroundView.frame = self.bounds;
    NSInteger bottomHeight = 0;
    NSInteger tableHeight = 0;
    // 取消键
    if (self.cancelButtonTitle) {
        [self.cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        self.cancelButton.frame = CGRectMake(0, self.frame.size.height - HEIGHT_BUTTON, self.frame.size.width, HEIGHT_BUTTON);
        [self.actionSheectView addSubview:self.cancelButton];
        bottomHeight += HEIGHT_BUTTON;
        tableHeight += SPACE_MIDDEL;
    } else {
        [self.cancelButton removeFromSuperview];
    }
    
    if (tableViewButtonCount * HEIGHT_BUTTON > self.frame.size.height - bottomHeight - 20) {
        tableHeight += (self.frame.size.height - bottomHeight - 20);
        [self.tableView setBounces:YES];
    } else {
        tableHeight += (tableViewButtonCount * HEIGHT_BUTTON);
        [self.tableView setBounces:NO];
    }
    if (self.title.length > 0) {
        self.headerTitleLabel.frame = CGRectMake(SPACE_TITLE_LEFT, SPACE_TITLE_TOP, self.frame.size.width - SPACE_TITLE_LEFT * 2, 0);
        self.headerTitleLabel.text = self.title;
        CGFloat hightTitle = [self.headerTitleLabel sizeThatFits:CGSizeMake(self.headerTitleLabel.frame.size.width, MAXFLOAT)].height;
        self.headerTitleLabel.frame = CGRectMake(self.headerTitleLabel.frame.origin.x, self.headerTitleLabel.frame.origin.y, self.headerTitleLabel.frame.size.width, hightTitle);
        
        CGFloat heightHeader = hightTitle + SPACE_TITLE_TOP * 2;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, heightHeader)];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:self.headerTitleLabel];
        
        if (self.destructiveButtonTitle || tableViewButtonCount > 0) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, heightHeader - 0.5, self.frame.size.width, 0.5)];
            lineView.backgroundColor = COLOR_SEPERATOR;
            [headerView addSubview:lineView];
        }
        self.tableView.tableHeaderView = headerView;
        tableHeight += heightHeader;
    }
    self.actionSheectView.frame = CGRectMake(0, self.frame.size.height - bottomHeight - tableHeight - HOME_INDICATOR_HEIGHT, self.frame.size.width, bottomHeight + tableHeight + HOME_INDICATOR_HEIGHT);
    self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, tableHeight);
    self.cancelButton.frame = CGRectMake(0, tableHeight, self.frame.size.width, HEIGHT_BUTTON);
}
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (animated) {
        CGRect rect = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.actionSheectView.frame.size.height);
        [UIView animateWithDuration:0.2 animations:^{
            self.actionSheectView.frame = rect;
            self.backgroundView.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    } else {
        [self removeFromSuperview];
    }
}
#pragma mark - Event Response
- (void)didTapBackground:(UIButton *)btn {
    if (self.clickAction) {
        self.clickAction(self.cancelButtonIndex);
    }
    if (self.cancelButtonTitle && self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [self.delegate actionSheet:self clickedButtonAtIndex:self.cancelButtonIndex];
    }
    [self dismissWithClickedButtonIndex:self.cancelButtonIndex animated:YES];
}
- (void)cancelButtonClicked:(UIButton *)btn {
    [self didTapBackground:nil];
}

#pragma mark - Getters
- (UIButton *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIButton alloc] init];
        [_backgroundView setBackgroundColor:[UIColor blueColor]];
        [_backgroundView addTarget:self action:@selector(didTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundView;
}
- (UIView *)actionSheectView {
    if (_actionSheectView == nil) {
        _actionSheectView = [[UIView alloc] init];
        [_actionSheectView setBackgroundColor:[UIColor whiteColor]];
    }
    return _actionSheectView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.rowHeight = HEIGHT_BUTTON;
        _tableView.backgroundColor = COLOR_TABLEVIEW_BG;
        _tableView.separatorColor = COLOR_SEPERATOR;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LEActionSheetCell"];
        if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            _tableView.separatorInset = UIEdgeInsetsZero;
        }
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}
- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] init];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:BUTTON_FONT_SIZE]];
        [_cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cancelButton;
}
- (UILabel *)headerTitleLabel {
    if (_headerTitleLabel == nil) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.textColor = [UIColor grayColor];
        _headerTitleLabel.font = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
        _headerTitleLabel.numberOfLines = 0;
        _headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _headerTitleLabel;
}
@end
