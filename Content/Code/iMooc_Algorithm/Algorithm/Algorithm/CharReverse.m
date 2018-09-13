//
//  CharReverse.m
//  Algorithm
//
//  Created by lqq on 2018/9/13.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "CharReverse.h"

@implementation CharReverse
void char_reverse(char * cha) {
    // 指向第一个字符
    char *begin = cha;
    // 指向字符串末尾
    char *end = cha + strlen(cha) - 1;
    while (begin < end) {
        // 交换字符，同时移动指针
        char temp = *begin;
        *(begin++) = *end;
        *(end--) = temp;
    }
}
@end
