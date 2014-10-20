//
//  HSWordCheckReportView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-11.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckReportViewCon.h"
#import "HSLearnCircleProgressView.h"
#import "WordDAL.h"
#import "WordLearnInfoModel.h"
#import "HSAppDelegate.h"

#pragma mark - ---------wordCell
@interface wordCell ()

@property (nonatomic, strong) UIButton *editWordBtn;
@property (nonatomic, strong) UIImageView *statusImgView;//正确或者错误的红蓝色圈圈
@property (nonatomic, strong) UILabel *labelCH;//中文
@property (nonatomic, strong) UILabel *labelEn;//英文
@property (nonatomic, assign) BOOL existNewWord;//是否已加入生词本
@property (nonatomic, assign) WordModel *wordModel;

@end

@implementation wordCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


-(void)loadDataWithWordModel:(WordModel *)wordModel
{
    self.wordModel = wordModel;
    self.labelCH.text = wordModel.chinese;
    self.labelEn.text = wordModel.tChinese;
    
    NSString *imgName = (wordModel.practicResult == kPracticeResultTypeRight)? @"hsWordCheck_blue_circle" : @"hsWordCheck_red_circle";
    
    self.statusImgView.image = [UIImage imageNamed:imgName];
}

#pragma mark - action
- (void)editWordBtnClick:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(wordCellEditWordBtnClick:)]) {
        [self.delegate wordCellEditWordBtnClick:self];
    }
}


#pragma mark - 初始化控件
-(UIButton *)editWordBtn{
    if (!_editWordBtn) {
        _editWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editWordBtn.backgroundColor = kClearColor;
        _editWordBtn.frame = CGRectMake(self.width - 60, 0, 60, 60);
        _editWordBtn.centerY = 30;
        [_editWordBtn addTarget:self action:@selector(editWordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editWordBtn];
    }
    return _editWordBtn;
}

-(UIImageView *)statusImgView{
    if (!_statusImgView) {
        _statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 0, 14, 14)];
        _statusImgView.centerY = 30;
        _statusImgView.backgroundColor = kClearColor;
        [self addSubview:_statusImgView];
    }
    return _statusImgView;
}


-(UILabel *)labelCH{
    if (!_labelCH) {
        _labelCH = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 20)];
        _labelCH.backgroundColor = kClearColor;
        _labelEn.textAlignment = NSTextAlignmentLeft;
        _labelCH.textColor = hsGlobalWordColor;
        _labelCH.font = [UIFont systemFontOfSize:17.0f];
        [self addSubview:_labelCH];
    }
    return _labelCH;
}

-(UILabel *)labelEn{
    if (!_labelEn) {
        _labelEn = [[UILabel alloc] initWithFrame:CGRectMake(self.labelCH.left, 30, self.labelCH.width, self.labelCH.height)];
        _labelEn.backgroundColor = kClearColor;
        _labelEn.textAlignment = NSTextAlignmentLeft;
        _labelEn.textColor = self.labelCH.textColor;
        _labelEn.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_labelEn];
    }
    return _labelEn;
}




@end




#pragma mark - ------------HSWordCheckReportView


#import "WordNet.h"
#import "CheckPointDAL.h"
#import "MessageHelper.h"
#import "CheckPointNet.h"

NSString *const kNextCheckPointNotification = @"NextCheckPointNotification";

#define bottomToolViewHeight 49

@interface HSWordCheckReportViewCon ()<AudioPlayHelperDelegate>

@property (nonatomic, strong) UIView *topResultView;
@property (nonatomic, strong) UITableView *wordsTableView;

@property (nonatomic, strong) UIView *bottomToolView;
@property (nonatomic, strong) UIButton *reTestBtn;
@property (nonatomic, strong) UIButton *nextLevelBtn;


@end



@implementation HSWordCheckReportViewCon
{
    WordNet *wordNet;
    CheckPointNet *cpNet;
    
    NSInteger trueNum;//对
    NSInteger falseNum;//错误
    CGFloat percent;//正确率
    //总进度
    CGFloat totalProgress;
    
    NSArray *topicModelArray;
    CGRect mainViewframe;
    
    BOOL isFromNewWrodIntoHere;
}


-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

-(id)initWithTopicModleArray:(NSArray *)modelArray{
    self = [super init];
    if (self)
    {
        topicModelArray = modelArray;
    }
    return self;
    
}

-(id)initWithTopicModleArray:(NSArray *)modelArray andIsFromNewWrodInto:(BOOL)isFromNewWrodInto
{
    isFromNewWrodIntoHere = isFromNewWrodInto;
    return [self initWithTopicModleArray:modelArray];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    mainViewframe = [UIScreen mainScreen].applicationFrame;
    
    UIImage *imgNavBack = [UIImage imageNamed:@"hsGlobal_back_icon.png"];
    CreatViewControllerImageBarButtonItem(imgNavBack, @selector(back:), self, YES);
    
    self.title = NSLocalizedString(@"测试报表", @"");
    
    wordNet = [[WordNet alloc] init];
    cpNet = [[CheckPointNet alloc] init];
    
    [self loadData];

    if (!isFromNewWrodIntoHere) {
        [self saveWordCheckRecordInfo:topicModelArray];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[AudioPlayHelper sharedManager] stopAudio];
    
    [CommonHelper googleAnalyticsPageView:@"测试报表"];
}

-(void)dealloc
{
    wordNet = nil;
    cpNet = nil;
    topicModelArray = nil;
}

- (void)saveWordCheckRecordInfo:(NSArray *)arrRecords
{
    __weak HSWordCheckReportViewCon *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger recordCount = [arrRecords count];
        __block NSInteger savedCount = 0;
        
        for (WordModel *wordModel in arrRecords)
        {
            BOOL right = (wordModel.practicResult == kPracticeResultTypeRight);
            [WordDAL loadWordCheckRecordInfoWithUserID:kUserID checkPointID:kAppDelegate.curCpID WordID:wordModel.wID completion:^(BOOL success, id obj, NSError *error){
                WordLearnInfoModel *wordLearned = (WordLearnInfoModel *)obj;
                NSInteger totalRights = wordLearned.rightsValue;
                NSInteger totalWrongs = wordLearned.wrongsValue;
                
                if (right)
                {
                    [wordLearned setTotalRightsTimes:(int32_t)++totalRights completion:^(BOOL finished, id obj, NSError *error) {
                        ++savedCount;
                        if (savedCount >= recordCount){
                            [weakSelf asyncWordLearnRecord];
                        }
                    }];
                }
                else
                {
                    [wordLearned setTotalWrongsTimes:(int32_t)++totalWrongs completion:^(BOOL finished, id obj, NSError *error) {
                        ++savedCount;
                        if (savedCount >= recordCount){
                            [weakSelf asyncWordLearnRecord];
                        }
                    }];
                }
                
                //DLog(@"加完之后: totalRights: %d; totalWrongs: %d", totalRights, totalWrongs);
                // 如果是未归档的
                if (wordLearned.statusValue == WordLearnFileStatusUnFile)
                {
                    NSInteger total = totalWrongs+totalRights;
                    NSInteger rPercent = total <= 0 ? 0 : totalRights/total;
                    if (total >= kFileTimes && rPercent >= kFilePercent)
                    {
                        [wordLearned setLearnedStatus:WordLearnFileStatusFiled completion:nil];
                    }
                }
            }];
        }
    });
}

- (void)asyncWordLearnRecord
{
    NSArray *arrWordRecord = [WordDAL queryWordLearnRecordInfosWithUserID:kUserID checkPointID:kAppDelegate.curCpID];
    NSMutableString *strRecords = [[NSMutableString alloc] init];
    for (WordLearnInfoModel *wordLearn in arrWordRecord)
    {
        @autoreleasepool
        {
            NSInteger rightTimes = wordLearn.rightsValue;
            NSInteger wrongTimes = wordLearn.wrongsValue;
            //DLog(@"正确和错误次数: totalRights: %d; totalWrongs: %d", rightTimes, wrongTimes);
            NSInteger status = wordLearn.statusValue;
            NSString *strRecord = [[NSString alloc] initWithFormat:@"%@|%@|%d|%d|%d,", wordLearn.cpID, wordLearn.wID, rightTimes, wrongTimes, status];
            [strRecords appendString:strRecord];
        }
    }
    
    if ([strRecords length] > 0) {
        [strRecords setString:[strRecords substringToIndex:[strRecords length]-1]];
    }
    
    __weak HSWordCheckReportViewCon *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wordNet startWordLearnedRecordsRequestWithUserEmail:kEmail checkPointID:kAppDelegate.curCpID bookID:kBookID categoryID:kCategoryID records:strRecords completion:^(BOOL finished, id result, NSError *error){
            [weakSelf refreshCheckPointProgress];
        }];
    });
}

- (void)refreshCheckPointProgress
{
    NSArray *arrWordRecord = [WordDAL queryWordLearnRecordInfosWithUserID:kUserID checkPointID:kAppDelegate.curCpID];
    
    NSInteger totalCount = [arrWordRecord count];
    CGFloat totalPercent = 0.0f;
    for (WordLearnInfoModel *wordLearn in arrWordRecord)
    {
        @autoreleasepool
        {
            NSInteger rightTimes = wordLearn.rightsValue;
            NSInteger wrongTimes = wordLearn.wrongsValue;
            NSInteger totalTimes = rightTimes+wrongTimes;
            NSInteger status = wordLearn.statusValue;
            
            if (status == WordLearnFileStatusFiled) {
                totalPercent++;
            }else{
                totalPercent += (totalTimes <= 0 ? 0 : (CGFloat)rightTimes/(CGFloat)totalTimes);
            }
        }
    }
    
    CGFloat progress = totalCount <= 0 ? 0 : totalPercent/totalCount;
    totalProgress = progress;
    DLog(@"保存本关进度: %f", totalProgress);
    // 保存本关的进度
    [CheckPointDAL saveCheckPointProgressWithUserID:kUserID CheckPointID:kAppDelegate.curCpID bookID:kBookID version:nil progress:totalProgress status:0 completion:^(BOOL finished, id obj, NSError *error) {}];
}

- (void)back:(id)send
{
    [[AudioPlayHelper sharedManager] stopAudio];
    if (self.deldgate && [self.deldgate respondsToSelector:@selector(backBtnClickAndIsNextLevel:)]) {
        [self.deldgate backBtnClickAndIsNextLevel:NO];
    }
}

- (void)loadData
{
    if (topicModelArray.count > 0) {
        for (int i = 0; i < topicModelArray.count; i++) {
            WordModel *tempModel = [topicModelArray objectAtIndex:i];
            (tempModel.practicResult == kPracticeResultTypeRight)? trueNum++ : falseNum++;
        }
        percent = (CGFloat)trueNum/(CGFloat)(trueNum + falseNum);
    }
    //显示测试结果view
    [self showResultData];
    
    self.topResultView.backgroundColor = kClearColor;
    self.wordsTableView.backgroundColor = kClearColor;
    self.reTestBtn.backgroundColor = kClearColor;
    
    [self judgeNextLevelBtnHidden];
}

- (void)judgeNextLevelBtnHidden{
    
    if (isFromNewWrodIntoHere) {
        return;
    }
    //如果下一关已开启 或者 本关得分不是80分  则显示下一关按钮

    __block BOOL hasNextLeave = NO;
    __weak HSWordCheckReportViewCon *weakSelf = self;
    NSString *nexCpID = kAppDelegate.nexCpID;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 判断下一关是否存在, 不存在即解锁
        CheckPointProgressModel *cpProgress = [CheckPointDAL queryCheckPointProgressWithUserID:kUserID bookID:kBookID checkPointID:nexCpID];
        
        //DLog(@"进度: %@", nexCpID);
        if (cpProgress) {
            hasNextLeave = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (hasNextLeave) {
                [weakSelf setNextLevelBtnStatus];
            }else if (!hasNextLeave && percent >= 0.8f) {
                [weakSelf setNextLevelBtnStatus];
                [MessageHelper showMessage:NSLocalizedString(@"恭喜！下一关已解锁", @"") view:self.view];
                // 解锁下一关，下一关解锁时默认的进度为0.
                [CheckPointDAL saveCheckPointProgressWithUserID:kUserID CheckPointID:nexCpID bookID:kBookID version:nil progress:0 status:0 completion:^(BOOL finished, id obj, NSError * error) {
                    // 同步解锁的关卡
                    [weakSelf synchronousCheckPointProgressWithCpID:nexCpID];
                }];
            }
        });
    });
}

#pragma mark - 网络请求
- (void)synchronousCheckPointProgressWithCpID:(NSString *)cpID
{
    // 同步本关进度
#ifdef DEBUG
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
#endif
    [cpNet startSynchronousCheckPointProgressWithEmail:kEmail bookID:kBookID records:cpID completion:^(BOOL finished, id result, NSError *error) {
#ifdef DEBUG
        CFTimeInterval end = CFAbsoluteTimeGetCurrent();
#endif
        DLog(@"同步用时: %f", end-start);
    }];
    
}


#pragma mark - 初始化各种页面及控件
-(UIView *)topResultView{
    if (!_topResultView) {
        CGFloat top = kIOS7 ? (kStatusBarHeight + kNavigationBarHeight ) : 0;
        _topResultView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.view.width, 130)];
        _topResultView.backgroundColor = kClearColor;
        [self.view addSubview:_topResultView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _topResultView.height - 1, self.view.width, 1)];
        line.backgroundColor = hsGlobalLineColor;
        [_topResultView addSubview:line];
    }
    return _topResultView;
}

-(UITableView *)wordsTableView{
    if (!_wordsTableView) {
        CGFloat height = self.bottomToolView.top - self.topResultView.bottom;
        _wordsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.topResultView.bottom,self.view.width,height) style:UITableViewStylePlain];
        _wordsTableView.backgroundColor = [UIColor clearColor];
        _wordsTableView.delegate = self;
        _wordsTableView.dataSource = self;
        [_wordsTableView setSeparatorColor:hsGlobalLineColor];
        _wordsTableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:_wordsTableView];
    }
    return _wordsTableView;
}


- (void)showResultData{
    //蓝色圆点
    UIImageView *blueCircleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 40, 14, 14)];
    blueCircleImgView.backgroundColor = [UIColor clearColor];
    blueCircleImgView.image = [UIImage imageNamed:@"hsWordCheck_blue_circle"];
    [self.topResultView addSubview:blueCircleImgView];
    
    //对的label
    UILabel *trueLabel = [[UILabel alloc] initWithFrame:CGRectMake(blueCircleImgView.right + 10, 0, 100, 20)];
    trueLabel.centerY = blueCircleImgView.centerY;
    trueLabel.backgroundColor = [UIColor clearColor];
    trueLabel.textColor = [UIColor grayColor];
    trueLabel.font = [UIFont systemFontOfSize:18.0f];
    
    NSString *trueStr = NSLocalizedString(@"对", @"");
    
    trueLabel.text = [NSString stringWithFormat:@"%@:  %i",trueStr,trueNum];
    [self.topResultView addSubview:trueLabel];
    
    //红色圆点
    UIImageView *redCircleImgView = [[UIImageView alloc] initWithFrame:blueCircleImgView.frame];
    redCircleImgView.backgroundColor = [UIColor clearColor];
    redCircleImgView.top = blueCircleImgView.bottom + 30;
    redCircleImgView.image = [UIImage imageNamed:@"hsWordCheck_red_circle"];
    [self.topResultView addSubview:redCircleImgView];
    
    //错的label
    UILabel *falseLabel = [[UILabel alloc] initWithFrame:trueLabel.frame];
    falseLabel.centerY = redCircleImgView.centerY;
    falseLabel.backgroundColor = trueLabel.backgroundColor;
    falseLabel.textColor = trueLabel.textColor;
    falseLabel.font = trueLabel.font;
    
    NSString *falseStr = NSLocalizedString(@"错", @"");
    
    falseLabel.text = [NSString stringWithFormat:@"%@:  %i",falseStr,falseNum];
    [self.topResultView addSubview:falseLabel];
    
    //进度圈圈
    HSLearnCircleProgressView  *circleProView = [[HSLearnCircleProgressView alloc] initWithFrame:CGRectMake(0, 30, 80, 80)];
    circleProView.right = self.view.width - 40;
    circleProView.backgroundColor = [UIColor clearColor];
    circleProView.animationDuration = 0.3f;
    circleProView.fillRadiusPx = 3.0f;
    circleProView.isFill = NO;
    circleProView.progressTintColor = hsShineBlueColor;
    circleProView.groundTintColor = [UIColor redColor];
    circleProView.userInteractionEnabled = NO;
    [circleProView setCurrent:percent animated:YES];
    [self.topResultView addSubview:circleProView];
    
    //进度label
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    progressLabel.center = circleProView.center;
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textAlignment = UITextAlignmentCenter;
    NSString *progressStr = [NSString stringWithFormat:@"%i",(int)(round(percent * 100))];
    progressLabel.text = [progressStr stringByAppendingString:@"%"];
    progressLabel.font = [UIFont systemFontOfSize:20.0f];
    progressLabel.textColor = trueLabel.textColor;
    [self.topResultView addSubview:progressLabel];
}


-(UIView *)bottomToolView{
    if (!_bottomToolView) {
        CGFloat top = kIOS7 ? 0 : kStatusBarHeight*2;
        _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - bottomToolViewHeight - top, self.view.width, bottomToolViewHeight)];
        _bottomToolView.backgroundColor = kClearColor;
        [self.view addSubview:_bottomToolView];
    }
    return _bottomToolView;
}

-(UIButton *)reTestBtn{
    if (!_reTestBtn) {
        _reTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reTestBtn.frame = CGRectMake(0, 0, self.bottomToolView.width, self.bottomToolView.height);
        _reTestBtn.backgroundColor = kClearColor;
        NSString *title = NSLocalizedString(@"重新测试", @"");
        [_reTestBtn setTitle:title forState:UIControlStateNormal];
        [_reTestBtn setTitleColor:hsShineBlueColor forState:UIControlStateNormal];
        [_reTestBtn setTitleColor:hsShineBlueColor forState:UIControlStateHighlighted];
        [_reTestBtn addTarget:self action:@selector(reTest:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomToolView addSubview:_reTestBtn];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
        line.backgroundColor = hsGlobalLineColor;
        [_bottomToolView addSubview:line];
    }
    return _reTestBtn;
}

-(UIButton *)setNextLevelBtnStatus{
    //DLOG_CMETHOD;
    if (!_nextLevelBtn) {
        
        //将重新开始按钮宽度缩短
        self.reTestBtn.width = self.bottomToolView.width/2;
        
        _nextLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextLevelBtn.frame = self.reTestBtn.frame;
        _nextLevelBtn.left = self.reTestBtn.right;
        _nextLevelBtn.backgroundColor = kClearColor;
        NSString *title = NSLocalizedString(@"下一关", @"");
        [_nextLevelBtn setTitle:title forState:UIControlStateNormal];
        [_nextLevelBtn setTitleColor:hsShineBlueColor forState:UIControlStateNormal];
        [_nextLevelBtn setTitleColor:hsShineBlueColor forState:UIControlStateHighlighted];
        [_nextLevelBtn addTarget:self action:@selector(nextLevelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomToolView addSubview:_nextLevelBtn];
        
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_nextLevelBtn.left, 0, 1, self.bottomToolView.height)];
        verticalLine.backgroundColor = hsGlobalLineColor;
        [_bottomToolView addSubview:verticalLine];
    }
    return _nextLevelBtn;
}


- (void)nextLevelBtnClick:(id)sender
{
    DLog(@"下一关");
    
    if (self.deldgate && [self.deldgate respondsToSelector:@selector(backBtnClickAndIsNextLevel:)]) {
        [self.deldgate backBtnClickAndIsNextLevel:YES];
    }
}


#pragma mark - action
- (void)reTest:(id)send{
    
    if (isFromNewWrodIntoHere) {
        [CommonHelper googleAnalyticsLogCategory:@"重新测试" action:@"测试报表操作" event:@"生词本重新测试" pageView:NSStringFromClass([self class])];
    }else{
        [CommonHelper googleAnalyticsLogCategory:@"重新测试" action:@"测试报表操作" event:@"普通重新测试" pageView:NSStringFromClass([self class])];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    if (self.deldgate && [self.deldgate respondsToSelector:@selector(reTest)]) {
        [self.deldgate reTest];
    }
}


#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [topicModelArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"cell";
    
    wordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[wordCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.width = self.view.width;
        cell.delegate = self;
    }
    
    
    WordModel *wordModel = (WordModel *)[topicModelArray objectAtIndex:indexPath.row];
    [cell loadDataWithWordModel:wordModel];
    
    //判断有无加入生词本
    BOOL existNewWord = [WordDAL existNewWordWithUserID:kUserID WordID:wordModel.wID];
    cell.existNewWord = existNewWord;
    if (existNewWord) {
        [cell.editWordBtn setImage:[UIImage imageNamed:@"hsGlobal_remove_words"] forState:UIControlStateNormal];
    }else{
        [cell.editWordBtn setImage:[UIImage imageNamed:@"hsGlobal_add_words"] forState:UIControlStateNormal];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //播放音频
    WordModel *wordModel = [topicModelArray objectAtIndex:indexPath.row];
    
    NSString *audio = wordModel.tAudio;
    [[AudioPlayHelper sharedManager] playAudioWithName:audio delegate:self];
    
}

#pragma mark - cell代理
-(void)wordCellEditWordBtnClick:(wordCell *)cell{
    NSTimeInterval created = [[[NSDate alloc] init] timeIntervalSince1970];
    if (cell.existNewWord) {
        [WordDAL saveWordReviewWithUserID:kUserID cpID:nil wordID:cell.wordModel.wID created:created status:NewWordStatusRemoved completion:^(BOOL finished, id obj, NSError *error) {
            [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view detail:NSLocalizedString(@"已移出生词本", @"") isHide:YES];

            
            [cell.editWordBtn setImage:[UIImage imageNamed:@"hsGlobal_add_words"] forState:UIControlStateNormal];
            cell.existNewWord = NO;
        }];
        
    }else{
        [WordDAL saveWordReviewWithUserID:kUserID cpID:nil wordID:cell.wordModel.wID created:created status:NewWordStatusAdd completion:^(BOOL finished, id obj, NSError *error) {
            [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view detail:NSLocalizedString(@"已加入生词本" , @"") isHide:YES];
            [cell.editWordBtn setImage:[UIImage imageNamed:@"hsGlobal_remove_words"] forState:UIControlStateNormal];
            cell.existNewWord = YES;
        }];
    }
}

@end
