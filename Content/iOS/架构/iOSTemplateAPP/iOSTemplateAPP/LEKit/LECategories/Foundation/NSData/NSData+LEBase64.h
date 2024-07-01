//
//  NSData+LEBase64.h
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/17.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LEBase64)


/**
 字符串base64转Data

 @param string 字符串
 @return Data
 */
+ (NSData *)lee_dataWithBase64EncodedString:(NSString *)string;

/**
 NSData转String

 @param wrapWidth 换行长度  76  64
 @return 字符串
 */
- (NSString *)lee_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;


/**
 默认64，换行长度。
 */
- (NSString *)lee_base64EncodedString;

@end

NS_ASSUME_NONNULL_END
