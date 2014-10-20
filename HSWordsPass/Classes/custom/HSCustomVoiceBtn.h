//
//  HSCustomVoiceBtn.h
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSCustomVoiceBtn : UIButton

@property (nonatomic, strong) UIImageView *voiceAnimationImgView;//发音动画

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;

@end
