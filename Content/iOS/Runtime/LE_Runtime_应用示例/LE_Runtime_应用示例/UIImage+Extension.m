//
//  UIImage+Extension.m
//  LE_Runtime_应用示例
//
//  Created by lqq on 2018/10/25.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "UIImage+Extension.h"
#import <objc/runtime.h>


@implementation UIImage (Extension)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m1 = class_getClassMethod([UIImage class], @selector(le_imageNamed:));
        Method m2 = class_getClassMethod([UIImage class], @selector(imageNamed:));
        method_exchangeImplementations(m1, m2);
    });
}
// 自定义方法，用来替换UIImage方法
+ (UIImage *)le_imageNamed:(NSString *)name {
    double osVersion = [[UIDevice currentDevice].systemVersion doubleValue];
    if (osVersion >= 7.0) {
        name = [name stringByAppendingString:@"_os7"];
    }
    return [self le_imageNamed:name];
}
@end
