//
//  AudioPlayHelper.h
//  HelloHSK
//
//  Created by yang on 14-3-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AVAudioPlayer;
@protocol AudioPlayHelperDelegate;

@interface AudioPlayHelper : NSObject
{
    AVAudioPlayer *player;
}

@property (strong, nonatomic)AVAudioPlayer *player;

+ (AudioPlayHelper *)sharedManager;

- (void)playAudioWithName:(NSString *)audio delegate:(id<AudioPlayHelperDelegate>)delegate;

- (void)stopAudio;

@end

@protocol AudioPlayHelperDelegate <NSObject>

@optional
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player;

@end
