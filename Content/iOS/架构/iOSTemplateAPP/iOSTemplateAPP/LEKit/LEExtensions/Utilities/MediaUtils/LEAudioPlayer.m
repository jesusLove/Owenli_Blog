//
//  LEAudioPlayer.m
//  iOSTemplateAPP
//
//  Created by LQQ on 2018/12/22.
//  Copyright © 2018 LQQ. All rights reserved.
//

#import "LEAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface LEAudioPlayer ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) void (^ completeBlock)(BOOL finished);
@end

@implementation LEAudioPlayer

+ (LEAudioPlayer *)sharedAudioPlayer {
    static LEAudioPlayer *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
- (void)playAudioAtPath:(NSString *)path complete:(void (^)(BOOL))complete {
    if (self.player && self.player.isPlaying) {
        [self stopPlayingAudio];
    }
    self.completeBlock = complete;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    self.player.delegate = self;
    if (error) {
        if (complete) {
            complete(NO);
        }
        return;
    }
    [self.player play];
}
- (void)stopPlayingAudio {
    [self.player stop];
    if (self.completeBlock) {
        self.completeBlock(NO);
    }
}
- (BOOL)isPlaying {
    if (self.player) {
        return self.player.isPlaying;
    }
    return NO;
}

#pragma mark - Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (self.completeBlock) {
        self.completeBlock(YES);
        self.completeBlock = nil;
    }
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    DDLogError(@"AudioPlayer Error: %@", error);
    if (self.completeBlock) {
        self.completeBlock(NO);
        self.completeBlock = nil;
    }
}


@end
