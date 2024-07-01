//
//  ViewReusePool.h
//  TableView重用机制
//
//  Created by lqq on 2018/8/3.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ViewReusePool : NSObject

- (UIView *)dequeueReuseableView; // 从重用池中获取一个View

- (void)addUsingView:(UIView *)view; //向重用池中添加一个View

- (void)reset; // 重置方法，将当前使用的视图移动到可重置队列中
@end
