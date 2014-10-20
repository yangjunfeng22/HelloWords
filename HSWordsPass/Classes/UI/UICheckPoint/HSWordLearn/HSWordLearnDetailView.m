//
//  HSWordLearnDetailView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordLearnDetailView.h"

#import "WordNet.h"
#import "WordDAL.h"
#import "WordModel.h"
#import "SentenceModel.h"

#import "WordReviewModel.h"

#import "TopicLabel.h"
#import "TTTAttributedLabel.h"

#import "HSAppDelegate.h"

@interface HSWordLearnExampleSentenceView()<AudioPlayHelperDelegate>

@property (nonatomic, strong) UIImageView *voiceAnimationImgView;//发音动画
@property (nonatomic, strong) UILabel *exampleSentenceLable;
@property (nonatomic, strong) UILabel *lblChineseSentence;

@end


@implementation HSWordLearnExampleSentenceView
{
    SentenceModel *senModel;
    
    WordNet *wordNet;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        wordNet = [[WordNet alloc] init];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor yellowColor];
        wordNet = [[WordNet alloc] init];
    }
    return self;
}

- (void)loadExampleSentenceDataWithSentence:(id)sentence
{
    senModel = (SentenceModel *)sentence;
    
    BOOL isEmptyPinyin = [[senModel.pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
    NSString *strFormt = isEmptyPinyin ? @"%@%@":@"%@^%@";
    
    NSString *strChinese = [[NSString alloc] initWithFormat:strFormt, senModel.chinese, senModel.pinyin];

    if (!kShowTone)
    {
        __weak NSString *Hightlight = _mainWordCH;
        [((TTTAttributedLabel *)self.lblChineseSentence) setText:strChinese afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            
            //NSRange range = NSMakeRange(0, mutableAttributedString.length);
            // Core Text APIs use C functions without a direct bridge to UIFont. See Apple's "Core Text Programming Guide" to learn how to configure string attributes.
            if (Hightlight)
            {
                NSRange strRange = [[mutableAttributedString string] rangeOfString:Hightlight options:NSLiteralSearch];
                [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:hsShineBlueColor range:strRange];
            }
            return mutableAttributedString;
        }];
    }
    else
    {
        ((TopicLabel *)self.lblChineseSentence).keyWordHighlightStr = self.mainWordCH;
        ((TopicLabel *)self.lblChineseSentence).text = strChinese;
    }
    
    [self.lblChineseSentence sizeToFit];
    
    self.exampleSentenceLable.text = senModel.tChinese;
    [_exampleSentenceLable sizeToFit];
    
    self.height = self.exampleSentenceLable.bottom;
}

-(HSCustomVoiceBtn *)voiceBtn{
    if (!_voiceBtn) {
        UIImage *imgVoice = [UIImage imageNamed:@"hsGlobal_ voice_1.png"];
        _voiceBtn = [HSCustomVoiceBtn buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectMake(10, 15, 26, 20);
        [_voiceBtn setImage:imgVoice forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(exampleSentencePlayAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (void)exampleSentencePlayAudio:(UIButton *)send
{
    NSString *audio = [senModel tAudio];
    [self playAudio:audio];
}

- (void)playAudio:(NSString *)audio
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:audio])
    {
        [[AudioPlayHelper sharedManager] playAudioWithName:audio delegate:self];
        [self.voiceBtn startAnimating];
    }
    else
    {
        __weak HSWordLearnExampleSentenceView *weakSelf = self;
        [wordNet downloadWordAudioDataWithEmail:kEmail checkPointID:kAppDelegate.curCpID audio:senModel.audio completion:^(BOOL finished, id result, NSError *error) {
            
            if (finished)
            {
                [[AudioPlayHelper sharedManager] playAudioWithName:result delegate:weakSelf];
                [weakSelf.voiceBtn startAnimating];
            }
        }];
    }
}

-(UILabel *)exampleSentenceLable{
    if (!_exampleSentenceLable) {
        _exampleSentenceLable = [[UILabel alloc] initWithFrame:CGRectMake(self.lblChineseSentence.left, self.lblChineseSentence.bottom+5, self.width - self.lblChineseSentence.left - 10, 0)];
        _exampleSentenceLable.numberOfLines = 0;
        _exampleSentenceLable.backgroundColor = [UIColor clearColor];
        _exampleSentenceLable.textColor = hsGlobalWordColor;
        
        [self addSubview:_exampleSentenceLable];
        
    }
    return _exampleSentenceLable;
}


- (UILabel *)lblChineseSentence
{
    if (!_lblChineseSentence)
    {
        NSInteger left = self.voiceBtn.right + 8;
        _lblChineseSentence = kShowTone ? [[TopicLabel alloc] initWithFrame:CGRectMake(left, self.voiceBtn.top, self.width - left - 10, 20.0f)] : [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(left, self.voiceBtn.top, self.width - left - 10, 20.0f)];
        _lblChineseSentence.numberOfLines = 0;
        _lblChineseSentence.backgroundColor = [UIColor clearColor];
        _lblChineseSentence.textColor = hsGlobalWordColor;
        
        [self addSubview:_lblChineseSentence];
    }
    return _lblChineseSentence;
}

#pragma mark - AudioPlayHelper Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.voiceBtn stopAnimating];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(exampleVedioPlayEnd)]) {
        [self.delegate exampleVedioPlayEnd];
    }
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self.voiceBtn stopAnimating];
}

- (void)dealloc
{
    wordNet = nil;
}

@end



#pragma mark - HSWordLearnDetailView
@interface HSWordLearnDetailView ()<AudioPlayHelperDelegate,HSWordLearnExampleDelegate>
{
    WordNet *wordNet;
}

@property (nonatomic, strong) UIView *topWordView;
@property (nonatomic, strong) UIView *topWordLineView;

@property (nonatomic, strong) UIScrollView *exampleSentenceScrollView;//例句Scroll

@property (nonatomic, strong) TopicLabel *mainWordCH;//主单词
@property (nonatomic, strong) UILabel *mainWordProperty;//属性
@property (nonatomic, strong) UILabel *mainWordEG;//英文

@property (nonatomic, strong) HSCustomVoiceBtn *voiceBtn;//发音按钮
@property (nonatomic, strong) UIButton *btnNewWord;//生词本
@property (nonatomic, strong) UIImageView *voiceAnimationImgView;//发音动画

@end

@implementation HSWordLearnDetailView
{
    NSString *wordID;
    WordModel *wordModel;
    NSMutableArray *arrSentence;
    
    BOOL isAutoPlayVedio;//是否自动播放
    NSInteger examplePlayVedioindex;//例句播放到第几句
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        wordNet = [[WordNet alloc] init];
        arrSentence = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)loadDataWithWord:(id)word
{
    wordModel = (WordModel *)word;
    wordID = wordModel.wID;
    
    [self voiceBtn];
    NSString *strChinese = [[NSString alloc] initWithFormat:@"%@^%@", wordModel.chinese, wordModel.pinyin];
    
    self.mainWordCH.text = strChinese;
    [self.mainWordCH sizeToFit];
    
    self.mainWordProperty.text = [[NSString alloc] initWithFormat:@"%@", wordModel.tProperty];
    [self.mainWordProperty sizeToFit];
    
    self.mainWordEG.text = wordModel.tChinese;
    [self.mainWordEG sizeToFit];
    
    self.mainWordProperty.bottom = self.mainWordCH.bottom ;
    self.topWordView.height = self.mainWordEG.bottom+20;
    [self topWordLineView];
    
    //加载例句
    
    NSArray *arrSentences = [wordModel sentences];
    if (arrSentences) {
        [arrSentence setArray:arrSentences];
    }
    __block NSInteger sentenceCount = [arrSentence count];
    
//    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:2];
//    
//    [arr addObjectsFromArray:arrSentence];
//    [arr addObjectsFromArray:arrSentence];
    
    if (sentenceCount <= 0)
    {
        __weak HSWordLearnDetailView *weakSelf = self;
        [wordNet startWordSentenceRequestWithUserEmail:kEmail checkPointID:@"1" wordID:wordID completion:^(BOOL finished, id result, NSError *error) {
            NSArray *arrSentences = [wordModel sentences];
            if (arrSentences) {
                [arrSentence setArray:arrSentences];
            }
            
            sentenceCount = [arrSentence count];
            [weakSelf loadExampleSentenceWithSentenceCount:sentenceCount];
        }];
    }
    [self loadExampleSentenceWithSentenceCount:sentenceCount];
    
}

- (void)loadExampleSentenceWithSentenceCount:(NSInteger)sentenceCount
{
    NSInteger tempHeight = 0;
    for (NSInteger i = 0; i < sentenceCount; i++)
    {
        HSWordLearnExampleSentenceView *exampleSentenceView = [[HSWordLearnExampleSentenceView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        exampleSentenceView.mainWordCH = wordModel.chinese;
        exampleSentenceView.delegate = self;
        [exampleSentenceView loadExampleSentenceDataWithSentence:[arrSentence objectAtIndex:i]];
        
        exampleSentenceView.top = tempHeight+5;
        exampleSentenceView.tag = exampleSentenceViewTag + i;
        [exampleSentenceView addTarget:self action:@selector(autoPlayVideo:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.exampleSentenceScrollView addSubview:exampleSentenceView];
        tempHeight = exampleSentenceView.bottom;
    }
    [self.exampleSentenceScrollView setContentSize:CGSizeMake(0.0f, tempHeight)];
}

-(UIScrollView *)exampleSentenceScrollView{
    if (!_exampleSentenceScrollView) {
        _exampleSentenceScrollView = [[UIScrollView alloc] init];
        _exampleSentenceScrollView.top = self.topWordView.bottom;
        _exampleSentenceScrollView.left = 0;
        _exampleSentenceScrollView.height = self.height - self.topWordView.height;
        _exampleSentenceScrollView.width = self.width;
        _exampleSentenceScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_exampleSentenceScrollView];
    }
    return _exampleSentenceScrollView;
}



-(TopicLabel *)mainWordCH{
    if (!_mainWordCH) {
        _mainWordCH = [[TopicLabel alloc] initWithFrame:CGRectMake(30, 25, self.width*0.5f, 70)];
        _mainWordCH.backgroundColor = [UIColor clearColor];
        _mainWordCH.textAlignment = NSTextAlignmentLeft;
        [_mainWordCH setTextColor:hsGlobalBlueColor];
        [_mainWordCH setFont:[UIFont systemFontOfSize:23.0f]];
        [self.topWordView addSubview:_mainWordCH];
    }
    return _mainWordCH;
}


-(UILabel *)mainWordProperty{
    if (!_mainWordProperty) {
        _mainWordProperty= [[UILabel alloc] initWithFrame:CGRectMake(self.mainWordCH.right+5, 0, 25, 40)];
        _mainWordProperty.bottom = self.mainWordCH.bottom;
        _mainWordProperty.backgroundColor = [UIColor clearColor];
        _mainWordProperty.textColor = hsGlobalWordColor;
        _mainWordProperty.font = [UIFont systemFontOfSize:15.0f];
        [self.topWordView addSubview:_mainWordProperty];
    }
    return _mainWordProperty;
}

-(UILabel *)mainWordEG{
    if (!_mainWordEG) {
        _mainWordEG = [[UILabel alloc]initWithFrame:CGRectMake(self.mainWordCH.left, self.mainWordCH.bottom+10, self.width-self.mainWordCH.left - 10, 30)];
        _mainWordEG.backgroundColor = [UIColor clearColor];
        _mainWordEG.textAlignment = NSTextAlignmentLeft;
        _mainWordEG.numberOfLines = 0;
        _mainWordEG.textColor = self.mainWordProperty.textColor;
        _mainWordEG.font = [UIFont systemFontOfSize:17.0f];
        [self.topWordView addSubview:_mainWordEG];
        
    }
    return _mainWordEG;
}


-(HSCustomVoiceBtn *)voiceBtn{
    if (!_voiceBtn) {
        UIImage *imgVoice = [UIImage imageNamed:@"hsGlobal_ voice_1.png"];
        _voiceBtn = [HSCustomVoiceBtn buttonWithType:UIButtonTypeCustom];
        _voiceBtn.frame = CGRectMake(self.btnNewWord.right+15, 0, imgVoice.size.width, imgVoice.size.height);
        _voiceBtn.centerY = self.mainWordCH.centerY;
        [_voiceBtn setImage:imgVoice forState:UIControlStateNormal];
        [_voiceBtn addTarget:self action:@selector(ibPlayAudio:) forControlEvents:UIControlEventTouchUpInside];
        [self.topWordView addSubview:_voiceBtn];
    }
    return _voiceBtn;
}

- (UIButton *)btnNewWord
{
    if (!_btnNewWord)
    {
        _btnNewWord = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNewWord.frame = CGRectMake(self.width - 106, 0, 36.0f, 36.0f);
        _btnNewWord.centerY = self.mainWordCH.centerY;
        _btnNewWord.backgroundColor = [UIColor clearColor];
        _btnNewWord.showsTouchWhenHighlighted = YES;
        [self.topWordView addSubview:_btnNewWord];
        [self refreshNewWordButtonStatus:_btnNewWord];
    }
    return _btnNewWord;
}

- (void)addNewWord:(id)sender
{
    __weak HSWordLearnDetailView *weakSelf = self;
    NSTimeInterval created = [[[NSDate alloc] init] timeIntervalSince1970];
    [WordDAL saveWordReviewWithUserID:kUserID cpID:kAppDelegate.curCpID wordID:wordID created:created status:NewWordStatusAdd completion:^(BOOL finished, id obj, NSError *error) {
        NSString *str = NSLocalizedString(@"已加入生词本", @"");
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:weakSelf detail:str isHide:YES];
        [weakSelf refreshNewWordButtonStatus:sender];
    }];
}

- (void)removeNewWord:(id)sender
{
    __weak HSWordLearnDetailView *weakSelf = self;
    NSTimeInterval created = [[[NSDate alloc] init] timeIntervalSince1970];
    [WordDAL saveWordReviewWithUserID:kUserID cpID:kAppDelegate.curCpID wordID:wordID created:created status:NewWordStatusRemoved completion:^(BOOL finished, id obj, NSError *error) {
        NSString *str = NSLocalizedString(@"已移出生词本", @"");
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:weakSelf detail:str isHide:YES];
        [weakSelf refreshNewWordButtonStatus:sender];
    }];
}

- (void)refreshNewWordButtonStatus:(UIButton *)btn
{
    UIImage *img;
    SEL actionAdd;
    SEL actionRemove;
    BOOL existNewWord = [WordDAL existNewWordWithUserID:kUserID WordID:wordID];
    if (existNewWord)
    {
        img = [UIImage imageNamed:@"hsGlobal_remove_words"];
        
        actionAdd = @selector(removeNewWord:);
        actionRemove = @selector(addNewWord:);
    }
    else
    {
        img = [UIImage imageNamed:@"hsGlobal_add_words"];
        
        actionAdd = @selector(addNewWord:);
        actionRemove = @selector(removeNewWord:);
    }
    
    [btn setImage:img forState:UIControlStateNormal];
    [btn removeTarget:self action:actionRemove forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:actionAdd forControlEvents:UIControlEventTouchUpInside];
}

- (void)ibPlayAudio:(UIButton *)send
{
    isAutoPlayVedio = NO;
    NSString *audio = [wordModel tAudio];
    [self playAudio:audio];
}

-(UIView *)topWordView{
    if (!_topWordView) {
        _topWordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 120)];
        _topWordView.backgroundColor = [UIColor clearColor];
        [self addSubview:_topWordView];
    }
    return _topWordView;
}

-(UIView *)topWordLineView{
    if (!_topWordLineView) {
        _topWordLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1.0f)];
        _topWordLineView.top = _topWordView.bottom;
        _topWordLineView.backgroundColor = hsGlobalLineColor;
        [self addSubview:_topWordLineView];
    }
    return _topWordLineView;
}

//滑至当前页面自动播放
- (void)playWordAudio
{
    isAutoPlayVedio = YES;
    examplePlayVedioindex = 0;
    
    NSString *audio = [wordModel tAudio];
    [self playAudio:audio];
}

- (void)playAudio:(NSString *)audio
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:audio])
    {
        [[AudioPlayHelper sharedManager] playAudioWithName:audio delegate:self];
        [self.voiceBtn startAnimating];
    }
    else
    {
        __weak HSWordLearnDetailView *weakSelf = self;
        [wordNet downloadWordAudioDataWithEmail:kEmail checkPointID:kAppDelegate.curCpID audio:wordModel.audio completion:^(BOOL finished, id result, NSError *error) {
            
            if (finished)
            {
                [[AudioPlayHelper sharedManager] playAudioWithName:result delegate:weakSelf];
                [weakSelf.voiceBtn startAnimating];
            }
        }];
    }
}

#pragma mark - AudioPlayHelper Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.voiceBtn stopAnimating];
    
    [self exampleVedioPlayEnd];
}


//例句音频播放结束后的代理
-(void)exampleVedioPlayEnd{
    //词汇的音频播放完 是否自动播放例句
    if (isAutoPlayVedio) {
        HSWordLearnExampleSentenceView *exampleSentenceView = (HSWordLearnExampleSentenceView *)[self viewWithTag:(exampleSentenceViewTag + examplePlayVedioindex)];
        
        [exampleSentenceView exampleSentencePlayAudio:exampleSentenceView.voiceBtn];
        examplePlayVedioindex ++;
    }
}

- (void)autoPlayVideo:(id)sender
{
    isAutoPlayVedio = NO;
    HSWordLearnExampleSentenceView *exampleSentenceView = (HSWordLearnExampleSentenceView *)sender;
    [exampleSentenceView exampleSentencePlayAudio:exampleSentenceView.voiceBtn];
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [self.voiceBtn stopAnimating];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    wordModel = nil;
    wordNet = nil;
}

@end
