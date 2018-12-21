//
//  NSDate+LEExtensions.h
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/17.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (LEExtensions)
#pragma mark - 基本时间参数
@property (nonatomic, assign, readonly) NSUInteger year;
@property (nonatomic, assign, readonly) NSUInteger month;
@property (nonatomic, assign, readonly) NSUInteger day;
@property (nonatomic, assign, readonly) NSUInteger hour;
@property (nonatomic, assign, readonly) NSUInteger minute;
@property (nonatomic, assign, readonly) NSUInteger second;
/// 时期几，整数
@property (nonatomic, assign, readonly) NSUInteger weekday;
/// 当前月份的天数
@property (nonatomic, assign, readonly) NSUInteger dayInMonth;
/// 是不是闰年
@property (nonatomic, assign, readonly) BOOL isLeapYear;



/**
 获取日月年小时分钟秒
 */
- (NSUInteger)lee_year;
- (NSUInteger)lee_month;
- (NSUInteger)lee_day;
- (NSUInteger)lee_hour;
- (NSUInteger)lee_minute;
- (NSUInteger)lee_second;
+ (NSUInteger)lee_year:(NSDate *)date;
+ (NSUInteger)lee_month:(NSDate *)date;
+ (NSUInteger)lee_day:(NSDate *)date;
+ (NSUInteger)lee_hour:(NSDate *)date;
+ (NSUInteger)lee_minute:(NSDate *)date;
+ (NSUInteger)lee_second:(NSDate *)date;

/**
 获取一年中的总天数
 */
- (NSUInteger)lee_daysInYear;
+ (NSUInteger)lee_daysInYear:(NSDate *)date;

#pragma mark - 日期格式化
/// YYYY年MM月dd日
- (NSString *)formatYMD;
/// 自定义分隔符
- (NSString *)formatYMDWithSeparate:(NSString *)separate;
/// MM月dd日
- (NSString *)formatMD;
/// 自定义分隔符
- (NSString *)formatMDWithSeparate:(NSString *)separate;
/// HH:MM:SS
- (NSString *)formatHMS;
/// HH:MM
- (NSString *)formatHM;
/// 星期几
- (NSString *)formatWeekday;
/// 月份
- (NSString *)formatMonth;
@end

NS_ASSUME_NONNULL_END
