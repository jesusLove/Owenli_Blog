//
//  CabDriver.h
//  FacadePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Car.h"
#import "Taximeter.h"


/**
 使用CabDriver做外观，可以简化真个服务系统。
 */
@interface CabDriver : NSObject

- (void)driveToLocation:(CGPoint)x;

@end
