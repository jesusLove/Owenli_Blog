//
//  ViewController.m
//  TableView重用机制
//
//  Created by lqq on 2018/8/3.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import "ViewController.h"
#import "IndexTableView.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, IndexedTableViewDataSource> {
    IndexTableView *tableView;
    UIButton *button;
    NSMutableArray *dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableView = [[IndexTableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 60) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.indexedDataSource = self;
    tableView.indexWidth = 60;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"reloadTable" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    dataSource = [NSMutableArray array];
    for (int i = 0; i < 100; i ++) {
        [dataSource addObject:@(i + 1)];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", dataSource[indexPath.row]];
    return cell;
}
#pragma mark - IndexTableViewDataSource
- (NSArray<NSString *> *)indexTitlesForIndexTableView:(UITableView *)tableView {
    static BOOL change = NO;
    if (change) {
        change = NO;
        return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K"];
    } else {
        change = YES;
        return @[@"A", @"B", @"C", @"D", @"E", @"F"];
    }
}

- (void)doAction {
    [tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
