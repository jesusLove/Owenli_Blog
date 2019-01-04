//
//  CabDriver.m
//  FacadePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "CabDriver.h"

@implementation CabDriver

- (void)driveToLocation:(CGPoint)x {
    Taximeter *meter = [[Taximeter alloc] init];
    [meter start];
    
    Car *car = [[Car alloc] init];
    [car releaseBrakes];
    [car changeGears];
    //...
    
    [meter stop];
}
@end
