/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"

@interface SDImageCacheConfig : NSObject

/**
 * Decompressing images that are downloaded and cached can improve performance but can consume lot of memory.
 * Defaults to YES. Set this to NO if you are experiencing a crash due to excessive memory consumption.
 */
@property (assign, nonatomic) BOOL shouldDecompressImages; // 压缩图片，默认为YES

/**
 * disable iCloud backup [defaults to YES]
 */
@property (assign, nonatomic) BOOL shouldDisableiCloud; // 不使用iCloud备份，默认为YES

/**
 * use memory cache [defaults to YES]
 */
@property (assign, nonatomic) BOOL shouldCacheImagesInMemory; // 使用内存缓存，默认为YES

/**
 * The reading options while reading cache from disk.
 * Defaults to 0. You can set this to mapped file to improve performance.
 */
@property (assign, nonatomic) NSDataReadingOptions diskCacheReadingOptions; // 磁盘读取选项

/**
 * The maximum length of time to keep an image in the cache, in seconds.
 */
@property (assign, nonatomic) NSInteger maxCacheAge; // 最大缓存时间，单位秒， 默认为一个周

/**
 * The maximum size of the cache, in bytes.
 */
@property (assign, nonatomic) NSUInteger maxCacheSize; // 最大缓存空间大小，单位字节

@end
