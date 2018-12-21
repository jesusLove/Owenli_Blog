//
//  NSBundle+LEAppIcon.h
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/19.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (LEAppIcon)

@property (nonatomic, strong, readonly) NSString *lee_appIconPath;
@property (nonatomic, strong, readonly) UIImage *lee_appIcon;

@end

NS_ASSUME_NONNULL_END
