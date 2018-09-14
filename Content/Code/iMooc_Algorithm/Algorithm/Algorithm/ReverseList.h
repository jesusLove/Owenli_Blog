//
//  ReverseList.h
//  Algorithm
//
//  Created by lqq on 2018/9/13.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Node.h"

@interface ReverseList : NSObject

// 链表反转
struct Node * reverseList(struct Node *head);
// 构建一个链表
struct Node * constructList(void);
// 打印链表
void printList(struct Node *head);

@end
