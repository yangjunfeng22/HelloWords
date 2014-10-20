//
//  HSCustomVoiceBtn.m
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCustomVoiceBtn.h"

@interface HSCustomVoiceBtn ()

@end

@implementation HSCustomVoiceBtn


+(id)buttonWithType:(UIButtonType)buttonType{
    return [super buttonWithType:buttonType];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kClearColor;
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [super addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    if (state == UIControlStateHighlighted) {
        self.voiceAnimationImgView.highlightedImage = image;
    }else{
        self.voiceAnimationImgView.image = image;
    }
    
    self.voiceAnimationImgView.bounds = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    self.voiceAnimationImgView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}



- (void)startAnimating
{
    [self.voiceAnimationImgView startAnimating];
}

-(void)stopAnimating
{
    
    [self.voiceAnimationImgView stopAnimating];
}

-(BOOL)isAnimating{
    return self.voiceAnimationImgView.isAnimating;
}

-(UIImageView *)voiceAnimationImgView
{
    if (!_voiceAnimationImgView) {
        _voiceAnimationImgView = [[UIImageView alloc] init];
        _voiceAnimationImgView.animationDuration = 1.2;
        
        _voiceAnimationImgView.highlightedAnimationImages = [NSArray arrayWithObjects:
                                                            [UIImage imageNamed:@"hsGlobal_ voice_w_0"],
                                                            [UIImage imageNamed:@"hsGlobal_ voice_w_1"],
                                                            [UIImage imageNamed:@"hsGlobal_ voice_w_2"], nil];
        
        _voiceAnimationImgView.animationImages = [NSArray arrayWithObjects:
                                                  [UIImage imageNamed:@"hsGlobal_ voice_0"],
                                                  [UIImage imageNamed:@"hsGlobal_ voice_1"],
                                                  [UIImage imageNamed:@"hsGlobal_ voice_2"], nil];
        
        [self addSubview:_voiceAnimationImgView];
    }
    
    return _voiceAnimationImgView;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self performSelectorOfTargetForControlEvent:UIControlEventTouchDown];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self isAnimating]){
        [self startAnimating];
    }
    
    [self performSelectorOfTargetForControlEvent:UIControlEventTouchUpInside];
}

- (void)performSelectorOfTargetForControlEvent:(UIControlEvents)controlEvent
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSSet *targetSet = [self allTargets];
        [targetSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            NSArray *arrAction = [self actionsForTarget:obj forControlEvent:controlEvent];
            for (NSString *strAction in arrAction)
            {
                SEL action = NSSelectorFromString(strAction);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [obj performSelectorOnMainThread:action withObject:self waitUntilDone:NO];
                });
            }
        }];
    });
}

@end
