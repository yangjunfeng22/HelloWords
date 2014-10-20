//
//  HSWordLearnDetailView.h
//  HSWordsPass
//
//  Created by Lu on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSCustomVoiceBtn.h"


@protocol HSWordLearnExampleDelegate <NSObject>
@required
- (void) exampleVedioPlayEnd;

@end

@interface HSWordLearnExampleSentenceView : UIControl

@property (nonatomic, weak) id <HSWordLearnExampleDelegate> delegate;

@property (nonatomic, copy) NSString *mainWordCH;

@property (nonatomic, strong) HSCustomVoiceBtn *voiceBtn;

- (void)loadExampleSentenceDataWithSentence:(id)sentence;

- (void)exampleSentencePlayAudio:(UIButton *)send;

@end



@interface HSWordLearnDetailView : UIView

- (void)loadDataWithWord:(id)word;

- (void)playWordAudio;

@end
