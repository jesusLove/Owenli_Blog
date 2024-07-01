//
//  IndexTableView.h
//  TableView重用机制
//
//  Created by lqq on 2018/8/3.
//  Copyright © 2018年 Elink. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IndexedTableViewDataSource <NSObject>
- (NSArray <NSString *>*)indexTitlesForIndexTableView:(UITableView *)tableView;
@end
@interface IndexTableView : UITableView
@property (nonatomic, weak) id <IndexedTableViewDataSource> indexedDataSource;
@property (nonatomic, assign) CGFloat indexWidth; // 索引宽度
@end
