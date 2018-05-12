//
//  TouchConsoleController.m
//  BridgePattern
//
//  Created by lqq on 2018/4/19.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "TouchConsoleController.h"

@implementation TouchConsoleController

/**
 super 和 self 在这里相同作用，因为子类并没有重载父类setCommand：方法。
 */
- (void)up {
    [super setCommand:kConsoleCommandUp];
}

- (void)down {
    [super setCommand:kConsoleCommandDown];
}

- (void)left {
    [super setCommand:kConsoleCommandLeft];
}
@end
