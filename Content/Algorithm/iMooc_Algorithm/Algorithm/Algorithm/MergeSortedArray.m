//
//  MergeSortedArray.m
//  Algorithm
//
//  Created by lqq on 2018/9/13.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "MergeSortedArray.h"

@implementation MergeSortedArray
// 将有序数组a和b的值合并到一个数组result中，且仍保持有序
void mergeSortedArray(int a[], int aLen, int b[], int bLen, int result[]) {
    int p = 0; // a 数组标记
    int q = 0; // b 数组标记
    int i = 0; // 当前存储位标记
    // 任意数组结束
    while (p < aLen && q < bLen) {
        // 将较小的按个插入到新数组中
        if (a[p] <= b[q]) {
            result[i] = a[p];
            p++;
        } else {
            result[i] = b[q];
            q++;
        }
        i++;
    }
    // a数组还有剩余
    while (p < aLen) {
        result[i] = a[p++];
        i++;
    }
    // b数组有剩余
    while (q < bLen) {
        result[i] = b[q++];
        i++;
    }
}
@end
