//
//  main.m
//  Algorithm
//
//  Created by lqq on 2018/9/13.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReverseList.h"
#import "MergeSortedArray.h"
void char_reverseTest() {
    char ch[] = "Hello, world";
    char_reverse(ch);
    printf("reverse result is %s \n", ch);
}
void list_reverseTest() {
    struct Node *head = constructList();
    printList(head);
    printf("---------\n");
    struct Node *newHead = reverseList(head);
    printList(newHead);
}

void array_mergeSortedTest() {
    int a[5] = {1, 3, 4, 5, 9};
    int b[6] = {2, 8, 10, 23, 32, 43};
    int result[11];
    mergeSortedArray(a, 5, b, 6, result);
    printf("merge result is ");
    for (int i = 0; i < 11; i++) {
        printf("%d ", result[i]);
    }
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // 字符串反转
//        char_reverseTest();
        // 链表反转
//        list_reverseTest();
        
        array_mergeSortedTest();
    }
    return 0;
}
