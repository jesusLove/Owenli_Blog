//
//  ViewController.m
//  RuntimeMessage
//
//  Created by lqq on 2018/4/27.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ViewController.h"

#import "RuntimeBasicViewController.h" // Runtime基础知识

@implementation ViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            RuntimeBasicViewController *vc = [[RuntimeBasicViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}
@end
