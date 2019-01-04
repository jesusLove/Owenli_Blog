//
//  FindMedian.m
//  Algorithm
//
//  Created by lqq on 2018/9/14.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import "FindMedian.h"

@implementation FindMedian
// 无序数组的中位数
int findMedian(int a[], int aLen) {
    
    int low = 0;
    int high = aLen - 1;
    
    // 中位下标
    int mid = (aLen - 1) / 2;
    // 第一遍快排
    int div = PartSort(a, low, high);
    
    while (div != mid) {
        if (mid < div) {
            // 左半区间
            div = PartSort(a, low, div - 1); // 递归
        } else {
            //右半区间
            div = PartSort(a, div + 1, high); // 递归
        }
    }
    return a[mid];
}

int PartSort(int a[], int start, int end) {
    // 两个哨兵
    int low = start;
    int high = end;
    // 关键数
    int key = a[end];
    while (low < high) {
        // 左边的值要比Key小
        while (low < high && a[low] <= key) {
            ++low;
        }
        // 右边的值要比Key大
        while (low < high && a[high] >= key) {
            --high;
        }
        // 交换两个哨兵对应的值
        if (low < high) {
            int temp = a[low];
            a[low] = a[high];
            a[high] = temp;
        }
    }
    // 交换关键数
    int temp = a[high];
    a[high] = a[end];
    a[end] = temp;
    return low;
}
@end
