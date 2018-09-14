//
//  HashFind.m
//  Algorithm
//
//  Created by lqq on 2018/9/14.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "HashFind.h"

@implementation HashFind
char findFirstChar(char *cha) {
    char result = '\0';
    // 用于存放每个字符出现的次数，下标为字符的ASCII值
    int array[256] = {0};
    char *p = cha;
    // 遍历字符串，根据ASCII值存入数组中
    while (*p != '\0') {
        // 字符对应的存储位置，进行次数+1操作。
        array[*(p++)]++;
    }
    //重置p指针
    p = cha;
    while (*p != '\0') {
        // 遇到第一个出现次数为1的字符，打印出结果。
        if (array[*p] == 1) {
            result = *p;
            break;
        }
        p++;
    }
    return result;
}
@end
