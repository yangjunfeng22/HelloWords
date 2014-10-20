//
//  HSNewWordLearnViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-9-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#pragma mark - 因业务需要 词汇学习页面单独做一个  和原学习页面分开

#import "HSNewWordLearnViewController.h"
#import "UINavigationController+Extern.h"
#import "HSWordLearnDetailView.h"
#import "WordModel.h"
#import "WordDAL.h"
#import "HSWordCheckViewController.h"
#import "MBProgressHUD.h"


#define bottomBarDefaultHeight 49
@interface HSNewWordLearnViewController ()<HSWordCheckDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UIView *bottomBar;//底部工具

@property (nonatomic, strong) UIButton *lastWordBtn;//上一词
@property (nonatomic, strong) UIButton *testBtn;//测试
@property (nonatomic, strong) UIButton *nextWordBtn;//下一词

@property (nonatomic, assign) NSInteger currentPageNum;

@end

@implementation HSNewWordLearnViewController
{
    CGRect frame;
    NSMutableArray *newWordModelArray;
    NSInteger wordInfoCount;//单词个数
    
    
    //用于练习的两个数组
    NSMutableArray *hasLearnWordArray;//用户以前翻阅过的词汇数组
    NSMutableArray *otherNOLearnWordArray;//其他的 未翻阅的词汇数组
    BOOL isFromChoiceInto;
    
    BOOL isFirstInto;//是否第一次进入，如果是第一次 则通过view will apper加载 否则不
}

#pragma mark - 初始化操作
-(id)initWithNewWordModelArray:(NSArray *)wordModelArray index:(NSInteger)index isFromChoice:(BOOL)isFromChoice
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        isFromChoiceInto = isFromChoice;
        
        //初始化数组
        newWordModelArray = [[NSMutableArray alloc] initWithCapacity:2];
        [newWordModelArray setArray:wordModelArray];
        otherNOLearnWordArray = [newWordModelArray mutableCopy];
        wordInfoCount = newWordModelArray.count;
        hasLearnWordArray = [[NSMutableArray alloc] initWithCapacity:2];
        _currentPageNum = index;
    }
    return self;
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
    
    self.title = NSLocalizedString(@"生词学习", @"");
    
    isFirstInto = YES;
    
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:[UIImage imageNamed:@"hsGlobal_back_icon.png"]];
    
    frame = [UIScreen mainScreen].bounds;
    
    self.mainScrollView.backgroundColor = kClearColor;
    self.lastWordBtn.backgroundColor = kClearColor;
    self.nextWordBtn.backgroundColor = kClearColor;
    self.testBtn.backgroundColor = hsGlobalBlueColor;
    
    //处理上下词按钮状态
    [self handleLastOrNextBtn];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [CommonHelper googleAnalyticsPageView:@"生词学习"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isFirstInto) {
        [self loadWordLearnViewWithPointWordIndex:_currentPageNum];
        isFirstInto = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[AudioPlayHelper sharedManager] stopAudio];
}

-(void)dealloc{
    [newWordModelArray removeAllObjects];
    newWordModelArray = nil;
    
    hasLearnWordArray = nil;
    otherNOLearnWordArray = nil;
}


#pragma mark - 词语详情视图

- (void)handleLastOrNextBtn{
    self.lastWordBtn.hidden = YES;
    
    if (wordInfoCount && wordInfoCount == 1) {
        self.nextWordBtn.hidden = YES;
    }
}

- (void)loadWordLearnViewWithPointWordIndex:(NSInteger)index
{
    //加载详细单词页面  如果未指定跳至指定词汇  则加载第一个  若指定 则滚动
    if (_currentPageNum != 0) {
        [self rollScroolView];
    }else{
        [self loadDetailView];
    }
}



- (void)loadDetailView
{
    HSWordLearnDetailView *detailView = (HSWordLearnDetailView *)[self.mainScrollView viewWithTag:newWordLearnTag + _currentPageNum];
    if (!detailView)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        WordModel *word = [newWordModelArray objectAtIndex:_currentPageNum];
        
        //查看过的词汇 添加到已查看词汇数组
        [hasLearnWordArray addObject:word];
        [otherNOLearnWordArray removeObject:word];
        
        
        CGRect detailViewFrame = CGRectMake(_currentPageNum * self.view.width, 0, self.view.width, self.view.height - bottomBarDefaultHeight);
        detailView = [[HSWordLearnDetailView alloc] initWithFrame:detailViewFrame];
        detailView.alpha = 0.0f;
        detailView.tag = newWordLearnTag + _currentPageNum;
        [detailView loadDataWithWord:word];
        [self.mainScrollView addSubview:detailView];
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            detailView.alpha = 1.0f;
        } completion:^(BOOL finished) {}];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    [detailView playWordAudio];
}



#pragma mark - action
- (void)rollScroolView
{
    CGFloat xOffset = _currentPageNum * self.view.width;
    CGFloat yOffset = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(xOffset, yOffset);
    [self.mainScrollView setContentOffset:offset animated:YES];
}


#pragma mark - 按钮操作
- (void) switchWord:(UIButton *)send
{
    NSInteger type = send.tag;
    if (type == 100001) {
        [self switchWordViewIsNext:NO];
    }else if (type == 100002){
        [self switchWordViewIsNext:YES];
    }
}


-(BOOL)switchWordViewIsNext:(BOOL)isNext{
    if (isNext) {
        _currentPageNum += 1;
        if (_currentPageNum > wordInfoCount-1) {
            _currentPageNum = wordInfoCount-1;
            return NO;
        }
    }else{
        _currentPageNum -= 1;
        if (_currentPageNum < 0) {
            _currentPageNum = 0;
            return NO;
        }
    }
    //滚动
    [self rollScroolView];
    return YES;
}


//测试
- (void) clickTestBtn:(UIButton *)send
{
    NSMutableArray *testArray = [hasLearnWordArray mutableCopy];
    NSMutableArray *tempOtherNewWordArray = [otherNOLearnWordArray mutableCopy];
    
    //先判断已经加载了多少词  由于列表一次加载10条  如果不足5条 说明所有生词不足5条 5条以下无法测试
    if (newWordModelArray.count < 5) {
        NSString *title = NSLocalizedString(@"抱歉，需要5个以上的词才可以测试", @"");
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view detail:title isHide:YES];
        return;
    }
    
    //如果用户查看的词汇个数大于10 那看了多少测试多少  看的少于10个  则凑最多10个
    if (testArray.count < 10) {
        [tempOtherNewWordArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WordModel *tempModel = (WordModel *)obj;
            [testArray addObject:tempModel];
            if (testArray.count >= 10) {
                *stop = YES;
            }
        }];
    }

    HSWordCheckViewController *wordCheckViewCon = [[HSWordCheckViewController alloc] init];
    wordCheckViewCon.delegate = self;
    wordCheckViewCon.hidesBottomBarWhenPushed = YES;
    [wordCheckViewCon loadData:testArray andIsFromNewWrodInto:YES];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wordCheckViewCon];
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark - scroll代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat distance = scrollView.contentOffset.x;
    NSInteger tempPageNum = distance/self.view.width;
    if (tempPageNum == _currentPageNum) {
        return;
    }
    [self handleEndScroll:distance];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        CGFloat distance = scrollView.contentOffset.x;
        [self handleEndScroll:distance];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    CGFloat distance = scrollView.contentOffset.x;
    [self handleEndScroll:distance];
}

- (void)handleEndScroll:(NSInteger)distance
{
    if (distance >= 0)
    {
        _currentPageNum = distance/self.view.width;
        //当滑到最后一页的时候  重新加载更多数据
        //如果是编辑状态进入的  则不自动加载更多
        if (!isFromChoiceInto) {
            if (_currentPageNum == (wordInfoCount - 1)) {
                NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:2];
                tempArr = [WordDAL fetchNewWordsShowWithUserID:kUserID fetchOffset:wordInfoCount fetchLimit:10];
                if (tempArr && tempArr.count != 0) {
                    [tempArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        WordReviewModel *model = (WordReviewModel *)obj;
                        [newWordModelArray addObject:model.word];
                        [otherNOLearnWordArray addObject:model.word];
                    }];
                    
                    wordInfoCount = newWordModelArray.count;
                    //修改scroll的contengsize
                    [_mainScrollView setContentSize:CGSizeMake(self.view.width * wordInfoCount, frame.size.height - kNavigationBarHeight - kStatusBarHeight - bottomBarDefaultHeight)];
                }
            }
        }
        
        //加载页面
        [self loadDetailView];
        
        //编辑按钮状态
        if (_currentPageNum == 0) {
            [UIView animateWithDuration:0.3f animations:^{
                self.lastWordBtn.alpha = 0;
                if (wordInfoCount != 1) {
                    self.nextWordBtn.hidden = NO;
                    self.nextWordBtn.alpha = 1;
                }
            } completion:^(BOOL finished) {
                self.lastWordBtn.hidden = YES;
                [self.bottomBar bringSubviewToFront:self.testBtn];
                
            }];
        }
        //到达最后一页
        else if (_currentPageNum == wordInfoCount-1)
        {
            [UIView animateWithDuration:0.3f animations:^{
                self.nextWordBtn.alpha = 0;
                if (_currentPageNum != 0) {
                    self.lastWordBtn.hidden = NO;
                    self.lastWordBtn.alpha = 1;
                }
                
            } completion:^(BOOL finished) {
                self.nextWordBtn.hidden = YES;
                [self.bottomBar bringSubviewToFront:self.testBtn];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                self.lastWordBtn.hidden = NO;
                self.nextWordBtn.hidden = NO;
                self.lastWordBtn.alpha = 1;
                self.nextWordBtn.alpha = 1;
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}



-(void)clickWordCheckBackBtnAndIsNextLevel:(BOOL)isnextLevel{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 初始化bar和按钮等

-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.height -= bottomBarDefaultHeight;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.delegate = self;
        [_mainScrollView setContentSize:CGSizeMake(self.view.width * newWordModelArray.count, frame.size.height - kNavigationBarHeight - kStatusBarHeight - bottomBarDefaultHeight)];
        _mainScrollView.pagingEnabled = YES;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}


- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, bottomBarDefaultHeight)];
        _bottomBar.bottom = self.view.bottom;
        _bottomBar.backgroundColor = [UIColor clearColor];
        if (!kIOS7) {
            _bottomBar.top =  self.view.height - bottomBarDefaultHeight - kNavigationBarHeight;
        }
        [self.view addSubview:_bottomBar];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomBar.width, 1.0f)];
        lineView.top = _bottomBar.top;
        lineView.backgroundColor = hsGlobalLineColor;
        [self.view addSubview:lineView];
    }
    
    return _bottomBar;
}


//初始化上下词按钮
-(UIButton *)lastWordBtn{
    if (!_lastWordBtn) {
        _lastWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lastWordBtn.frame = CGRectMake(0, 0, self.bottomBar.width/3, bottomBarDefaultHeight);
        _lastWordBtn.backgroundColor = [UIColor clearColor];
        [_lastWordBtn setTitleColor:hsGlobalWordColor forState:UIControlStateNormal];
        _lastWordBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_lastWordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_lastWordBtn setTitle:NSLocalizedString(@"上一词", @"") forState:UIControlStateNormal];
        [_lastWordBtn setTag:100001];
        [_lastWordBtn addTarget:self action:@selector(switchWord:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:_lastWordBtn];
    }
    return _lastWordBtn;
}

-(UIButton *)testBtn{
    if (!_testBtn) {
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _testBtn.frame = CGRectMake(self.bottomBar.width/3, 0, self.bottomBar.width/3, bottomBarDefaultHeight);
        _testBtn.backgroundColor = hsGlobalBlueColor;
        [_testBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _testBtn.titleLabel.font = self.lastWordBtn.titleLabel.font;
        [_testBtn setTitle:NSLocalizedString(@"开始测试", @"") forState:UIControlStateNormal];
        [_testBtn addTarget:self action:@selector(clickTestBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:_testBtn];
    }
    return _testBtn;
}

- (UIButton *)nextWordBtn{
    if (!_nextWordBtn) {
        _nextWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextWordBtn.frame = CGRectMake(self.bottomBar.width/3*2, 0, self.bottomBar.width/3, bottomBarDefaultHeight);
        _nextWordBtn.backgroundColor = [UIColor clearColor];
        [_nextWordBtn setTitleColor:hsGlobalWordColor forState:UIControlStateNormal];
        _nextWordBtn.titleLabel.font = self.lastWordBtn.titleLabel.font;
        [_nextWordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_nextWordBtn setTitle:NSLocalizedString(@"下一词", @"") forState:UIControlStateNormal];
        [_nextWordBtn setTag:100002];
        [_nextWordBtn addTarget:self action:@selector(switchWord:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:_nextWordBtn];
    }
    return _nextWordBtn;
}



@end
