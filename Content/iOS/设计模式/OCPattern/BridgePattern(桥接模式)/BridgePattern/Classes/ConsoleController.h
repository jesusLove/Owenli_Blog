//
//  ConsoleController.h
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConsoleEmulator.h"

@interface ConsoleController : NSObject

@property (nonatomic, strong) ConsoleEmulator *emulator;

- (void)setCommand:(ConsoleCommand)command;

@end
