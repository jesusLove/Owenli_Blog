//
//  ConsoleEmulator.h
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ConsoleCommand) {
    kConsoleCommandUp,
    kConsoleCommandDown,
    kConsoleCommandLeft
};


@interface ConsoleEmulator : NSObject


/**
 将具体的操作命令加载到内部数据结构中。

 @param command 操作命令
 */
- (void)loadInstructionsForCommand:(ConsoleCommand)command;

- (void)executeInstructions;

// 其他行为属性

@end
