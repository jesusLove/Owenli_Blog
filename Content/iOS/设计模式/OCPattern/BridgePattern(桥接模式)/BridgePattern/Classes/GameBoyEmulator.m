//
//  GameBoyEmulator.m
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "GameBoyEmulator.h"

@implementation GameBoyEmulator

- (void)loadInstructionsForCommand:(ConsoleCommand)command {
    [super loadInstructionsForCommand: command];
    NSLog(@"GameBoyEmulator - %ld", command);
}
- (void)executeInstructions {
    [super executeInstructions];
    NSLog(@"GameBoyEmulator - executeInstructions");
}

@end
