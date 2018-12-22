//
//  LEAudioPlayer.h
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/22.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LEAudioPlayer : NSObject
@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (LEAudioPlayer *)sharedAudioPlayer;

- (void)playAudioAtPath:(NSString *)path complete:(void (^)(BOOL finished))complete;

- (void)stopPlayingAudio;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
