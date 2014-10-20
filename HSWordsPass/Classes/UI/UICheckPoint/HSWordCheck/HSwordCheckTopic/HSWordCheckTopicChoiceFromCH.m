//
//  HSWordCheckTopicChoiceFromCH.m
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckTopicChoiceFromCH.h"
#import "HSCustomVoiceBtn.h"
#import "HSAppDelegate.h"
#import "TopicLabel.h"

@interface HSWordCheckTopicChoiceFromCH ()

@property (nonatomic, strong)TopicLabel *wordLabel;//中文词语
@property (nonatomic, strong)HSCustomVoiceBtn *voiceBtn;//声音按钮

@end

@implementation HSWordCheckTopicChoiceFromCH
{
    WordModel *tempWordModel;
}


#pragma mark - 根据中文选择释义
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(void)loadTopicDataWithWordModel:(WordModel *)wordModel{
    tempWordModel = wordModel;
    
    if (kShowTone) {
        BOOL isEmptyPinyin = [[tempWordModel.pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
        NSString *strFormt = isEmptyPinyin ? @"%@%@":@"%@^%@";
        
        NSString *strChinese = [[NSString alloc] initWithFormat:strFormt, tempWordModel.chinese, tempWordModel.pinyin];
        
        self.wordLabel.text = strChinese;
    }else{
        self.wordLabel.text = tempWordModel.chinese;
    }
    
    [self.wordLabel sizeToFit];
    _wordLabel.center = self.center;
    
    self.voiceBtn.backgroundColor = kClearColor;
    [self.voiceBtn setImage:[UIImage imageNamed:@"hsGlobal_ voice_1"] forState:UIControlStateNormal];
}


-(UILabel *)wordLabel{
    if (!_wordLabel) {
        _wordLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(15, 30, self.width - 20, 90)];
        _wordLabel.backgroundColor = kClearColor;
        _wordLabel.textColor = hsShineBlueColor;
        _wordLabel.textAlignment = UITextAlignmentCenter;
        _wordLabel.font = [UIFont systemFontOfSize:20.0f];
        _wordLabel.numberOfLines = 1;
        [self addSubview:_wordLabel];
    }
    return _wordLabel;
}


-(HSCustomVoiceBtn *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [HSCustomVoiceBtn buttonWithType:UIButtonTypeCustom];
        _voiceBtn.size = CGSizeMake(26, 20);
        _voiceBtn.left = self.wordLabel.right+20;
        _voiceBtn.centerY = self.wordLabel.centerY;
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (void)voiceBtnClick:(HSCustomVoiceBtn *)btn
{
    //[btn startAnimatingInView:self];
    //NSLog(@"播放声音");
    
    NSString *audio = [tempWordModel tAudio];
    [[AudioPlayHelper sharedManager] playAudioWithName:audio delegate:self];
    
    // 开始动画
    [self.voiceBtn startAnimating];
    
}


#pragma mark - AudioPlayHelper Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.voiceBtn stopAnimating];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self.voiceBtn stopAnimating];
}

- (void)playWordAudio
{
    [self voiceBtnClick:self.voiceBtn];
}

@end
