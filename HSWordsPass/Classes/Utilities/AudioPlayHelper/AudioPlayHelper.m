//
//  AudioPlayHelper.m
//  HelloHSK
//
//  Created by yang on 14-3-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "AudioPlayHelper.h"
#import <AVFoundation/AVFoundation.h>

// 1、全局静态对象、并置为nil。
static AudioPlayHelper *audioPlay = nil;

@interface AudioPlayHelper ()<AVAudioPlayerDelegate>

@property (weak, nonatomic)id<AudioPlayHelperDelegate>delegate;

@end

@implementation AudioPlayHelper
@synthesize player;

// 2、构造实例
+ (AudioPlayHelper *)sharedManager
{
    @synchronized(self)
    {
        if (nil == audioPlay)
        {
            audioPlay = [[AudioPlayHelper alloc] init];
        }
    }
    return audioPlay;
}

// 3、重写allocwithzone，保证只有一个实例
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == audioPlay)
        {
            audioPlay = [super allocWithZone:zone];
            return audioPlay;
        }
    }
    return nil;
}

// 4、重写copywithzone
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self)
    {
        self = [super init];
        
        
        return self;
    }
}

- (void)playAudioWithName:(NSString *)audio delegate:(id<AudioPlayHelperDelegate>)delegate
{
    [self stopAudio];
    [self initAudioPlayerWithSource:audio delegate:delegate];
    [self playAudio];
}

- (void)initAudioPlayerWithSource:(NSString *)source delegate:(id<AudioPlayHelperDelegate>)delegate
{
    //NSLog(@"%@: source: %@", NSStringFromSelector(_cmd), source);
    if ([[NSFileManager defaultManager] fileExistsAtPath:source])
    {
        NSError *error;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:source isDirectory:NO] error:&error];
        player.delegate = self;
        [player prepareToPlay];
        
        //NSLog(@"code: %d; info: %@", error.code, error.domain);
        //NSLog(@"duration: %f", player.duration);
        //NSLog(@"currentTime: %f", player.currentTime);
        //NSLog(@"device currentTime: %f", player.deviceCurrentTime);
    }
    
    self.delegate = delegate;
}

- (void)playAudio
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
    if (player)
    {
        [player play];
        
        // 阻止锁屏
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
}

- (void)stopAudio
{
    if (player)
    {
        [player stop];
        player = nil;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerBeginInterruption:)])
    {
        [self.delegate audioPlayerBeginInterruption:player];
    }
    
    // 还原锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)aPlayer successfully:(BOOL)flag
{
    // 还原锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerDidFinishPlaying:successfully:)])
    {
        [self.delegate audioPlayerDidFinishPlaying:aPlayer successfully:flag];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)aPlayer
{
    // 还原锁屏
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayerBeginInterruption:)])
    {
        [self.delegate audioPlayerBeginInterruption:aPlayer];
    }
}

#pragma mark - Memory Manager

- (void)dealloc
{
    audioPlay = nil;
}

@end
