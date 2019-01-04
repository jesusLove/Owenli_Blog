//
//  MergeSortedArray.h
//  Algorithm
//
//  Created by lqq on 2018/9/13.
//  Copyright © 2018年 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MergeSortedArray : NSObject
// 将有序数组a和b的值合并到一个数组result中，且仍保持有序
void mergeSortedArray(int a[], int aLen, int b[], int bLen, int result[]);
@end
