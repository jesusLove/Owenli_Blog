//
//  ReverseList.m
//  Algorithm
//
//  Created by lqq on 2018/9/13.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "ReverseList.h"

@implementation ReverseList
// 链表反转
struct Node * reverseList(struct Node *head) {
    // 定义变量指针，初始化为头结点
    struct Node *p = head;
    // 反转后的链表头
    struct Node *newH = NULL;
    while (p != NULL) {
        // 记录下一个结点
        struct Node *temp = p -> next;
        p->next = newH;
        // 更新链表头部为当前节点
        newH = p;
        // 移动P指针
        p = temp;
    }
    return newH;
}
// 构建一个链表
struct Node * constructList(void) {
    // 头结点
    struct Node *head = NULL;
    // 记录当前节点
    struct Node *cur = NULL;
    
    for (int i = 0; i < 5; i++) {
        struct Node *node = malloc(sizeof(struct Node));
        node->data = i;
        
        if (head == NULL) {
            head = node;
        } else {
            cur->next = node;
        }
        cur = node;
    }
    return head;
}
// 打印链表
void printList(struct Node *head) {
    struct Node *temp = head;
    while (temp != NULL) {
        printf("node is %d \n", temp->data);
        temp = temp->next;
    }
}
@end
