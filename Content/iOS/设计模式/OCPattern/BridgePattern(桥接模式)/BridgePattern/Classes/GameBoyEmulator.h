//
//  GameBoyEmulator.h
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ConsoleEmulator.h"

@interface GameBoyEmulator : ConsoleEmulator


// 从抽象类重载的行为

- (void)loadInstructionsForCommand:(ConsoleCommand)command;
- (void)executeInstructions;

@end
