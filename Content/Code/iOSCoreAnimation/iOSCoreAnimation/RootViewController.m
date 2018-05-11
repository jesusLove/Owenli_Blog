//
//  ViewController.m
//  iOSCoreAnimation
//
//  Created by lqq on 2018/5/8.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "RootViewController.h"

#import "TransformViewController.h"
#import "Transform3DViewController.h"
#import "CAShapeLayerViewController.h"
#import "CATextLayerViewController.h"
#import "TransactionViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *vc = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            vc = [[TransformViewController alloc] init];
            
        }
            break;
        case 1:
        {
            vc = [[Transform3DViewController alloc] init];
            
        }
            break;
        case 2:
        {
            vc = [[CAShapeLayerViewController alloc] init];
            
        }
            break;
        case 3:
        {
            vc = [[CATextLayerViewController alloc] init];
        }
            break;
        case 4:
        {
            vc = [[TransactionViewController alloc] init];
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];

}

@end
