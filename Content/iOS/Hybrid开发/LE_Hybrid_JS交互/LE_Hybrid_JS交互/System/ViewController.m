//
//  ViewController.m
//  LE_Hybrid_JS交互
//
//  Created by lqq on 2018/10/26.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "ViewController.h"
#import "HookViewController.h"
#import "JSCoreViewController.h"
#import "JSBridgeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            HookViewController *hookVC = [[HookViewController alloc] init];
            [self.navigationController pushViewController:hookVC animated:YES];
        }
            break;
        case 1: {
            JSCoreViewController *coreVC = [[JSCoreViewController alloc] init];
            [self.navigationController pushViewController:coreVC animated:YES];
            break;
        }
        case 2: {
            JSBridgeViewController *bridgeVC = [[JSBridgeViewController alloc] init];
            [self.navigationController pushViewController:bridgeVC animated:YES];
            break;
        }
        default:
            break;
    }
}



@end
