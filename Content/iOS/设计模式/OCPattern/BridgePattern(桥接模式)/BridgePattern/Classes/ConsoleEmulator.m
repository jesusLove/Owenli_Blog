//
//  ConsoleEmulator.m
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ConsoleEmulator.h"

@implementation ConsoleEmulator

- (void)loadInstructionsForCommand:(ConsoleCommand)command {
    NSLog(@"ConsoleEmulator - %ld", command);
}

- (void)executeInstructions {
    NSLog(@"ConsoleEmulator - executeInstructions");
}

@end
