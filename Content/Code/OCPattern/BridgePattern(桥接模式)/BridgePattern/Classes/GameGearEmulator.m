//
//  GameGearEmulator.m
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "GameGearEmulator.h"

@implementation GameGearEmulator

- (void)loadInstructionsForCommand:(ConsoleCommand)command {
    [super loadInstructionsForCommand: command];
    NSLog(@"GameGearEmulator - %ld", command);
}
- (void)executeInstructions {
    [super executeInstructions];
    NSLog(@"GameGearEmulator - executeInstructions");
}
@end
