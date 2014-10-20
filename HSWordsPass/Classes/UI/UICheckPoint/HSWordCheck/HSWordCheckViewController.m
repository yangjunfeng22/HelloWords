//
//  HSWordCheckViewController.m
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckViewController.h"
#import "HSWordListViewController.h"
#import "HSWordLearnViewController.h"
#import "HSWordCheckDataFormat.h"

#import "HSWordCheckTopicManageView.h"

#import "UserLaterStatuModel.h"
#import "UserDAL.h"

#import "WordDAL.h"
#import "WordModel.h"
#import "MBProgressHUD.h"
#import "UINavigationController+Extern.h"



@interface HSWordCheckViewController ()
@property (nonatomic, strong) UILabel *progressLabel;//进度数字
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIBarButtonItem *topicCardBtnItem;
@property (nonatomic, strong) HSWordCheckTopicCardViewCon *topicCardViewCon;//答题卡

@end


@implementation HSWordCheckViewController{
    NSMutableArray *wordArrar;//词汇的数组
    NSMutableArray *newWordArray;//打乱之后的数组
    
    NSInteger testInfoCount;
    NSInteger currentPageNum;
    CGRect mainFrame;
    UIViewController *temp;
    HSWordCheckTopicType hSWordCheckTopicType;
    BOOL isFromNewWrodIntoHere;
    
    BOOL isFirstInto;//是否第一次进入，如果是第一次 则通过view will apper加载 否则不
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.title = NSLocalizedString(@"测试", @"");
    mainFrame = [UIScreen mainScreen].bounds;
    
    isFirstInto = YES;
    
    if (kIOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    //左右导航按钮
    UIImage *imgNavBack = [UIImage imageNamed:@"hsGlobal_back_icon.png"];
    CreatViewControllerImageBarButtonItem(imgNavBack, @selector(backToSomeCon:), self, YES);
    _topicCardBtnItem = CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"topic_card_icon"], @selector(popupTopicCardView), self, NO);
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [CommonHelper googleAnalyticsPageView:@"测试页面"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (isFirstInto) {
        //加载第一道题
        [self createTopic:0];
        isFirstInto = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[AudioPlayHelper sharedManager] stopAudio];
    
    [super viewWillDisappear:animated];
}

#pragma mark - 加载数据
- (void)loadData:(NSArray *)wordModelArrary{
    wordArrar = nil;
    
    wordArrar = [[NSMutableArray alloc] initWithCapacity:2];
    [wordArrar setArray:wordModelArrary];
    testInfoCount = wordArrar.count;

    //打乱数组并添加数据
    [self loadDataWithNewWordArray];
}

-(void)loadData:(NSArray *)wordModelArrary andIsFromNewWrodInto:(BOOL)isFromNewWrodInto{
    [self loadData:wordModelArrary];
    isFromNewWrodIntoHere = isFromNewWrodInto;
}


- (void)loadDataWithNewWordArray
{
    newWordArray = [NSMutableArray arrayWithCapacity:2];
    [newWordArray removeAllObjects];
    
    //打乱顺序后的数据
    newWordArray = [hsGetSharedInstanceClass(HSWordCheckDataFormat) chaosArrayFromArry:[wordArrar mutableCopy] withReturnNumber:wordArrar.count];
    
    self.mainScrollView.backgroundColor = [UIColor clearColor];
    
    self.progressLabel.text = [NSString stringWithFormat:@"1/%i",testInfoCount];
    
    //答题卡
    [self.mainScrollView addSubview:self.topicCardViewCon.view];
    CGFloat tempTop = kIOS7 ? -64 : 0;
    self.topicCardViewCon.view.frame = CGRectMake(testInfoCount*self.view.width, tempTop, self.view.width, self.mainScrollView.height);
    [_topicCardViewCon loadDataWithAllTopicArray:newWordArray];
}

#pragma mark - 查询数据库 按算法自动生成测试题
- (void)createTopic:(NSInteger)index
{
    //如果存在  则不再新建加载
    HSWordCheckTopicManageView *topicManageView = (HSWordCheckTopicManageView *)[self.mainScrollView viewWithTag:(kWordCheckTopic + index)];
    if (!topicManageView) {
        //先随机生成一种题目类型
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hSWordCheckTopicType = arc4random()%3;
        
        topicManageView = [[HSWordCheckTopicManageView alloc] initWithHSWordCheckTopicType:hSWordCheckTopicType];
        topicManageView.frame = CGRectMake(index * mainFrame.size.width, 0, mainFrame.size.width, self.mainScrollView.height);
        topicManageView.delegate = self;
        topicManageView.tag = kWordCheckTopic + index;
        
        //==============
        WordModel *currentTopicModel = [newWordArray objectAtIndex:index];
        //生成包含当前词汇的4个答案
        NSMutableArray *tempMutableArry = [newWordArray mutableCopy];
        [tempMutableArry removeObject:currentTopicModel];
        //随机从额外的题目中获取3个词汇
//        NSMutableArray *resultModelArry = [hsGetSharedInstanceClass(HSWordCheckDataFormat) chaosArrayFromArry:tempMutableArry withReturnNumber:3];
        
        NSMutableArray *resultModelArry = [hsGetSharedInstanceClass(HSWordCheckDataFormat) chaosArrayFromWordModelArry:tempMutableArry andSelfWordModel:currentTopicModel];
        
        [resultModelArry addObject:currentTopicModel];
        
        NSMutableArray *normalResultModelArry = [hsGetSharedInstanceClass(HSWordCheckDataFormat) chaosArrayFromArry:resultModelArry withReturnNumber:resultModelArry.count];
        //==============
        
        //加载数据
        [topicManageView loadDataWithModel:currentTopicModel aneResultModelArr:normalResultModelArry];
        
        [self.mainScrollView addSubview:topicManageView];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    [topicManageView playWordAudio];
}

#pragma mark - HSWordCheckViewDelegate
-(void)choiceResultItemAndResult:(BOOL)isTrue{
    WordModel *tempModel = [newWordArray objectAtIndex:currentPageNum];
    tempModel.practicResult = isTrue ? kPracticeResultTypeRight : kPracticeResultTypeWrong;
    //添加到答题卡页面
    [self.topicCardViewCon loadDataWithAllTopicArray:newWordArray];
    //滚动
    [self performSelector:@selector(rollScroolView) withObject:nil afterDelay:0.2f];
}


- (void)rollScroolView
{
    currentPageNum += 1;
    
    CGFloat xOffset = currentPageNum * self.view.width;
    CGFloat yOffset = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(xOffset, yOffset);
    [self.mainScrollView setContentOffset:offset animated:YES];
}

#pragma mark - scroll代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat distance = scrollView.contentOffset.x;
    NSInteger tempPage = distance/self.view.width;
    if (tempPage == currentPageNum) {
        return;
    }
    [self handleEndScroll:distance];
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat distance = scrollView.contentOffset.x;
    [self handleEndScroll:distance];
}

- (void)handleEndScroll:(NSInteger)distance
{
    if (distance >= 0)
    {
        currentPageNum = distance/self.view.width;
        [self handleScroolResult];
    }
}


- (void)handleScroolResult{
    //如果进去答题卡页面 则关闭答题卡按钮
    if (currentPageNum == testInfoCount) {
        _topicCardBtnItem.enabled = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.title = NSLocalizedString(@"答题卡", @"");
            _topicCardBtnItem.customView.alpha = 0;
            self.progressLabel.alpha = 0;
        } completion:^(BOOL finished) {
            _topicCardBtnItem.customView.hidden = YES;
            self.progressLabel.height = 0;
            
            [[AudioPlayHelper sharedManager] stopAudio];
        }];
    }else{
        //创建题目
        [self createTopic:currentPageNum];
        //显示答题卡按钮
        _topicCardBtnItem.enabled = YES;
        self.progressLabel.text = [NSString stringWithFormat:@"%i/%i",(currentPageNum+1),testInfoCount];
        [UIView animateWithDuration:0.2f animations:^{
            self.title = NSLocalizedString(@"测试", @"");
            self.progressLabel.alpha = 1;
            self.progressLabel.height = 13;
            
            _topicCardBtnItem.customView.hidden = NO;
            _topicCardBtnItem.customView.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
}


#pragma mark - 初始化各种视图

-(UILabel *)progressLabel{
    if (!_progressLabel) {
        CGFloat top = kIOS7 ? 69 : 5;
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-50, top, 50, 13)];
        _progressLabel.font = [UIFont systemFontOfSize:13.0f];
        _progressLabel.textColor = hsShineBlueColor;
        _progressLabel.textAlignment = UITextAlignmentCenter;
        _progressLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_progressLabel];
    }
    return _progressLabel;
}

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.delegate = self;
        //宽度+1 因为有答题卡页面
        [_mainScrollView setContentSize:CGSizeMake(self.view.width * (testInfoCount + 1), mainFrame.size.height - kNavigationBarHeight - kStatusBarHeight)];
        _mainScrollView.pagingEnabled = YES;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}


-(HSWordCheckTopicCardViewCon *)topicCardViewCon{
    if (!_topicCardViewCon) {
        _topicCardViewCon = [[HSWordCheckTopicCardViewCon alloc] initWithTopicModelCount:testInfoCount];
        _topicCardViewCon.delegate = self;
    }
    return _topicCardViewCon;
}


#pragma mark - 返回或者退出按钮控制
- (void)backToSomeCon:(id)send{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)backToLevelAndIsNextLevel:(BOOL)isNextLevel
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickWordCheckBackBtnAndIsNextLevel:)]) {
        [self.delegate clickWordCheckBackBtnAndIsNextLevel:isNextLevel];
    }
}

#pragma mark - 弹出答题卡
- (void)popupTopicCardView{
    HSWordCheckTopicCardViewCon *tempTopicCardViewCon = [[HSWordCheckTopicCardViewCon alloc] initWithTopicModelCount:testInfoCount];
    tempTopicCardViewCon.topicModelArray = newWordArray;
    tempTopicCardViewCon.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tempTopicCardViewCon];
    [self presentViewController:nav animated:YES completion:^{
    }];
}

//答题卡代理
-(void)jumpToTargetTopicPage:(NSInteger)topic{
    CGFloat xOffset = topic * self.view.width;
    CGFloat yOffset = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(xOffset, yOffset);
    [self.mainScrollView setContentOffset:offset animated:YES];
}


-(void)submitAndGoToReportView{
    //测试报表页面
    HSWordCheckReportViewCon *reportViewCon = [[HSWordCheckReportViewCon alloc] initWithTopicModleArray:newWordArray andIsFromNewWrodInto:isFromNewWrodIntoHere];
    
    reportViewCon.deldgate = self;
    [self.navigationController pushViewController:reportViewCon animated:YES];
}


-(void)reTest{
    DLog(@"重新测试");
    isFirstInto = YES;
    [self recoverWordData];
    [self.mainScrollView removeAllSubviews];
    [self loadDataWithNewWordArray];
    [self jumpToTargetTopicPage:0];
}


-(void)backBtnClickAndIsNextLevel:(BOOL)isNextLevel{
    [self backToLevelAndIsNextLevel:isNextLevel];
}

//恢复数据
- (void)recoverWordData{
    [wordArrar enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WordModel *model = (WordModel *)obj;
        model.practicResult = kPracticeResultTypeDefault;
    }];
}


-(void)dealloc{
    [self recoverWordData];
    
    wordArrar = nil;
    newWordArray = nil;
}
@end
