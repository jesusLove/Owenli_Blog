//
//  LEActionSheet.h
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/19.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LEActionSheet;

@protocol LEActionSheetDelegate <NSObject>

@optional
- (void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface LEActionSheet : UIView

@property (nonatomic, assign, readonly) NSInteger numberOfButtons;

@property (nonatomic, assign, readonly) NSInteger cancelButtonIndex;

@property (nonatomic, assign, readonly) NSInteger destructiveButtonIndex;

@property (nonatomic, weak) id <LEActionSheetDelegate> delegate;

@property(nonatomic, copy) void (^clickAction)(NSInteger buttonIndex);

- (instancetype)initWithTitle:(NSString *)title
                     delegate:(nullable id<LEActionSheetDelegate>)delegate
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
       destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;

- (instancetype)initWithTitle:(NSString *)title
                  clickAction:(void (^)(NSInteger buttonIndex))clickAction
            cancelButtonTitle:(nullable NSString *)cancelButtonTitle
       destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
            otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;


- (void)show;


- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;

@end

NS_ASSUME_NONNULL_END
