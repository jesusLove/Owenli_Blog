//
//  MergeSortedList.m
//  Algorithm
//
//  Created by lqq on 2018/9/13.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "MergeSortedList.h"
#import "Node.h"
@implementation MergeSortedList
struct Node * mergeSortedList(struct Node *aL, struct Node *bL) {
    // 判空操作
    if (aL == NULL) {
        return bL;
    } else if (bL == NULL){
        return aL;
    }
    struct Node *newH = NULL; // 新链表
    // 如果a链表结点值小于b链表则newH指向
    if (aL->data < bL->data) {
        newH = aL;
        // 递归
        newH->next = mergeSortedList(aL->next, bL);
    } else {
        newH = bL;
        // 递归
        newH->next = mergeSortedList(aL, bL->next);
    }
    return newH;
}
@end
