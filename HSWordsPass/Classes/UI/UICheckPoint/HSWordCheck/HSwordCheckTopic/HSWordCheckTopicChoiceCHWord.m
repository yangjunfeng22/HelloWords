//
//  HSWordCheckTopicChoiceCHWord.m
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckTopicChoiceCHWord.h"
#import "HSCustomVoiceBtn.h"
#import "SentenceModel.h"
#import "HSAppDelegate.h"
#import "TopicLabel.h"

@interface HSWordCheckTopicChoiceCHWord ()

@property (nonatomic, strong)TopicLabel *exampleSentenceLabel;//例句
@property (nonatomic, strong)UILabel *exampleSentenceENLabel;//英文
@property (nonatomic, strong)HSCustomVoiceBtn *voiceBtn;//声音按钮


@end

@implementation HSWordCheckTopicChoiceCHWord
{
    SentenceModel *tempSentenceModel;
}

#pragma mark - 选词填空
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(void)loadTopicDataWithWordModel:(WordModel *)wordModel{

    tempSentenceModel = [wordModel sentence];
    
    NSString *sentenceStr = tempSentenceModel.chinese;
    NSString *pinyinStr = tempSentenceModel.pinyin;
    
    NSString *word = wordModel.chinese;
    
    if (kShowTone) {
        BOOL isEmptyPinyin = [[tempSentenceModel.pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
        NSString *strFormt = isEmptyPinyin ? @"%@%@":@"%@^%@";
        
        
        NSString *str = [sentenceStr stringByReplacingOccurrencesOfString:word withString:@"___"];
        NSString *pinyinTempStr = [self doPinyinWithKeyWord:word andChineseStr:sentenceStr andPinyinStr:pinyinStr];
        
        NSString *strChinese = [[NSString alloc] initWithFormat:strFormt, str, pinyinTempStr];
        
        self.exampleSentenceLabel.text = strChinese;
        self.exampleSentenceLabel.textAlignment = NSTextAlignmentCenter;
        [self.exampleSentenceLabel sizeToFit];
        self.exampleSentenceLabel.numberOfLines = 2;
        self.exampleSentenceLabel.centerX = self.width/2;
        
    }else{
        NSString *str = [sentenceStr stringByReplacingOccurrencesOfString:word withString:@"___"];
        self.exampleSentenceLabel.numberOfLines = 2;
        self.exampleSentenceLabel.text = str;
    }
    
    
    self.exampleSentenceENLabel.text = tempSentenceModel.tChinese;
    self.exampleSentenceENLabel.top = self.exampleSentenceLabel.bottom + 10;
    [self.voiceBtn setImage:[UIImage imageNamed:@"hsGlobal_ voice_1"] forState:UIControlStateNormal];
    
    self.height = self.exampleSentenceENLabel.bottom + 13;
}


- (NSString *)doPinyinWithKeyWord:(NSString *)keyWord andChineseStr:(NSString *)chineseStr andPinyinStr:(NSString *)pinyinStr
{
    
    NSMutableArray *chineseArr = [NSMutableArray arrayWithArray:[chineseStr componentsSeparatedByString:@" "]] ;
    NSMutableArray *keyWordArr = [NSMutableArray arrayWithArray:[keyWord componentsSeparatedByString:@" "]];
    NSMutableArray *pinyinArr = [NSMutableArray arrayWithArray:[pinyinStr componentsSeparatedByString:@" "]];
    
    NSMutableIndexSet *set = [NSMutableIndexSet indexSet];
    NSMutableArray *sapceArr = [NSMutableArray arrayWithCapacity:2];
    
    
    for (int i = 0; i < keyWordArr.count; i++) {
        NSString *tempStr = [keyWordArr objectAtIndex:i];
        
        [chineseArr indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:tempStr]) {
                [set addIndex:idx];
                return YES;
            }else{
                return NO;
            }
        }];
    }
    
    
    for (int i = 0; i < set.count; i++) {
        [sapceArr addObject:@""];
    }
    
    [pinyinArr replaceObjectsAtIndexes:set withObjects:sapceArr];

    return [pinyinArr componentsJoinedByString:@" "];
    
}




#pragma mark - ui
-(TopicLabel *)exampleSentenceLabel{
    if (!_exampleSentenceLabel) {
        _exampleSentenceLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(10, 70, self.width - 20, 50)];
        _exampleSentenceLabel.backgroundColor = kClearColor;
        _exampleSentenceLabel.textColor = hsShineBlueColor;
        _exampleSentenceLabel.textAlignment = UITextAlignmentCenter;
        _exampleSentenceLabel.font = [UIFont systemFontOfSize:17.0f];
        _exampleSentenceLabel.numberOfLines = 2;
        [self addSubview:_exampleSentenceLabel];
    }
    return _exampleSentenceLabel;
}

-(UILabel *)exampleSentenceENLabel{
    if (!_exampleSentenceENLabel) {
        _exampleSentenceENLabel = [[UILabel alloc] init];
        _exampleSentenceENLabel.left = self.exampleSentenceLabel.left;
        _exampleSentenceENLabel.width = self.exampleSentenceLabel.width;
        _exampleSentenceENLabel.height = 50;
        _exampleSentenceENLabel.top = self.exampleSentenceLabel.bottom;
        _exampleSentenceENLabel.backgroundColor = kClearColor;
        _exampleSentenceENLabel.textColor = hsGlobalWordColor;
        _exampleSentenceENLabel.textAlignment = UITextAlignmentCenter;
        _exampleSentenceENLabel.font = [UIFont systemFontOfSize:14.0f];
        _exampleSentenceENLabel.numberOfLines = 2;
        [self addSubview:_exampleSentenceENLabel];
    }
    return _exampleSentenceENLabel;
}

-(HSCustomVoiceBtn *)voiceBtn{
    if (!_voiceBtn) {
        _voiceBtn = [HSCustomVoiceBtn buttonWithType:UIButtonTypeCustom];
        _voiceBtn.size = CGSizeMake(26, 20);
        _voiceBtn.centerX = self.width/2;
//        _voiceBtn.top = self.exampleSentenceLabel.bottom;
        _voiceBtn.bottom = self.exampleSentenceLabel.top - 20;
        [_voiceBtn addTarget:self action:@selector(voiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (void)voiceBtnClick:(HSCustomVoiceBtn *)btn
{
    //[btn startAnimatingInView:self];
    //NSLog(@"播放声音");
    
    NSString *audio = [tempSentenceModel tAudio];
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
