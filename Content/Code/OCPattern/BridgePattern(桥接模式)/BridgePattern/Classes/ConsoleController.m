//
//  ConsoleController.m
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ConsoleController.h"
#import "GameBoyEmulator.h"

@interface ConsoleController ()

@end

@implementation ConsoleController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.emulator = [[GameBoyEmulator alloc] init];
    }
    return self;
}
- (void)setCommand:(ConsoleCommand)command {
    [self.emulator loadInstructionsForCommand:command];
    [self.emulator executeInstructions];
}
@end
