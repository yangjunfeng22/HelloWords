//
//  HSWordLearnView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordLearnView.h"
#import "HSWordLearnDetailView.h"

#import "HSWordCheckViewController.h"
#import "HSHomeViewController.h"

#import "WordDAL.h"
#import "WordModel.h"
#import "HSAppDelegate.h"
#import "UserLaterStatuModel.h"
#import "UserDAL.h"
#import "MBProgressHUD.h"
#import "HSWordLearnViewController.h"

#define bottomBarDefaultHeight 49

@interface HSWordLearnView ()
{
    NSMutableArray *arrWord;
}

@property (nonatomic, strong) UIView *bottomBar;//底部工具

@property (nonatomic, strong) UIButton *lastWordBtn;//上一词
@property (nonatomic, strong) UIButton *testBtn;//测试
@property (nonatomic, strong) UIButton *nextWordBtn;//下一词

@property (nonatomic, strong) UILabel *progressLabel;//进度数字

@end


@implementation HSWordLearnView
{

    UIActivityIndicatorView *activityIndicatorView;
    
    NSInteger wordInfoCount;//单词个数
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPageNum = 0;
        _willPageNum = 0;
        arrWord = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}


-(void)loadDataWithModelArray:(NSArray *)modelArray
{
    
    self.backgroundColor = [UIColor clearColor];
    
    [self testBtn];
    [self nextWordBtn];
    
    //处理上下词按钮状态
    [self handleLastOrNextBtn];
    
    wordInfoCount = modelArray.count;
    [arrWord setArray:modelArray];
    
    //加载详细单词页面  如果未指定跳至指定词汇  则加载第一个  若指定 则滚动
    if (_currentPageNum != 0 || _willPageNum != 0) {
        [self rollScroolView];
    }else{
        [self loadDetailView];
    }
}


- (void)handleLastOrNextBtn{
    self.lastWordBtn.hidden = YES;
    
    if (wordInfoCount && wordInfoCount == 1) {
        self.nextWordBtn.hidden = YES;
    }else{
        //self.testBtn.centerX = self.lastWordBtn.centerX;
    }
}

- (void)loadDetailView
{
    
    self.progressLabel.text = [NSString stringWithFormat:@"%i/%i",(_currentPageNum+1),wordInfoCount];
    
    HSWordLearnDetailView *detailView = (HSWordLearnDetailView *)[self.mainScrollView viewWithTag:wordLearnTag + _willPageNum];
    if (!detailView)
    {
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        
        WordModel *word = [arrWord objectAtIndex:_currentPageNum];
        
        CGRect frame = CGRectMake(_willPageNum * self.width, 0, self.width, self.height - bottomBarDefaultHeight);
        detailView = [[HSWordLearnDetailView alloc] initWithFrame:frame];
        detailView.alpha = 0.0f;
        detailView.tag = wordLearnTag + _willPageNum;
        [detailView loadDataWithWord:word];
        [self.mainScrollView addSubview:detailView];
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            detailView.alpha = 1.0f;
        } completion:^(BOOL finished) {}];
        
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    }
    
    [detailView playWordAudio];
}


-(BOOL)switchWordViewIsNext:(BOOL)isNext{
    if (isNext) {
        _willPageNum += 1;
        if (_willPageNum > wordInfoCount-1) {
            _willPageNum = wordInfoCount-1;
            return NO;
        }
    }else{
        _willPageNum -= 1;
        if (_willPageNum < 0) {
            _willPageNum = 0;
            return NO;
        }
    }
    //滚动
    [self rollScroolView];
    return YES;
}


- (void)rollScroolView
{
    CGFloat xOffset = _willPageNum * self.width;
    CGFloat yOffset = self.mainScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(xOffset, yOffset);
    [self.mainScrollView setContentOffset:offset animated:YES];
}

#pragma mark - scroll代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat distance = scrollView.contentOffset.x;
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
        _currentPageNum = distance/self.width;
        
        //修改learn view con 中的pag (历史遗留问题)
         HSWordLearnViewController *con = (HSWordLearnViewController *)self.firstViewController;
        con.curIndex = _currentPageNum;
        
        _willPageNum = _currentPageNum;
        
        [self loadDetailView];
        
        __weak HSWordLearnView *weakSelf = self;
        if (_currentPageNum == 0) {
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.lastWordBtn.alpha = 0;
                if (wordInfoCount != 1) {
                    weakSelf.nextWordBtn.hidden = NO;
                    weakSelf.nextWordBtn.alpha = 1;
                    //self.testBtn.centerX = self.lastWordBtn.centerX;
                }
            } completion:^(BOOL finished) {
                weakSelf.lastWordBtn.hidden = YES;
                [weakSelf.bottomBar bringSubviewToFront:weakSelf.testBtn];
                
            }];
        }
        else if (_currentPageNum == wordInfoCount-1)
        {
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.nextWordBtn.alpha = 0;
                if (_currentPageNum != 0) {
                    weakSelf.lastWordBtn.hidden = NO;
                    weakSelf.lastWordBtn.alpha = 1;
                    
                    //self.testBtn.centerX = self.nextWordBtn.centerX;
                }
                
            } completion:^(BOOL finished) {
                weakSelf.nextWordBtn.hidden = YES;
                [weakSelf.bottomBar bringSubviewToFront:weakSelf.testBtn];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3f animations:^{
                //self.testBtn.centerX = self.bottomBar.centerX;
                
                weakSelf.lastWordBtn.hidden = NO;
                weakSelf.nextWordBtn.hidden = NO;
                weakSelf.lastWordBtn.alpha = 1;
                weakSelf.nextWordBtn.alpha = 1;
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}


#pragma mark - 初始化ui
-(UILabel *)progressLabel{
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width-50, 5, 50, 13)];
        _progressLabel.font = [UIFont systemFontOfSize:13.0f];
        _progressLabel.textColor = hsShineBlueColor;
        _progressLabel.textAlignment = UITextAlignmentCenter;
        _progressLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_progressLabel];
    }
    return _progressLabel;
}


-(UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainScrollView.height = self.height - bottomBarDefaultHeight;
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        
        [_mainScrollView setContentSize:CGSizeMake(self.width * wordInfoCount, self.height - bottomBarDefaultHeight)];
        _mainScrollView.pagingEnabled = YES;
        [self addSubview:_mainScrollView];
    }
    return _mainScrollView;
}


- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, bottomBarDefaultHeight)];
        _bottomBar.top = self.height-bottomBarDefaultHeight;
        _bottomBar.backgroundColor = [UIColor clearColor];
        [self addSubview:_bottomBar];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomBar.width, 1.0f)];
        lineView.top = _bottomBar.top;
        lineView.backgroundColor = hsGlobalLineColor;
        [self addSubview:lineView];
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
        [_lastWordBtn setTitleColor:hsShineBlueColor forState:UIControlStateHighlighted];
        _lastWordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
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
        _testBtn.frame = CGRectMake(self.bottomBar.width/3, 1, self.bottomBar.width/3, bottomBarDefaultHeight-1);
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
        [_nextWordBtn setTitleColor:hsShineBlueColor forState:UIControlStateHighlighted];
        [_nextWordBtn setTitle:NSLocalizedString(@"下一词", @"") forState:UIControlStateNormal];
        [_nextWordBtn setTag:100002];
        [_nextWordBtn addTarget:self action:@selector(switchWord:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:_nextWordBtn];
    }
    return _nextWordBtn;
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

- (void) clickTestBtn:(UIButton *)send
{
    
    [CommonHelper googleAnalyticsLogCategory:@"词汇学习模块操作" action:@"详情页操作" event:@"详情页开始测试" pageView:NSStringFromClass([self class])];
    
    
    HSWordCheckViewController *wordCheckViewCon = [[HSWordCheckViewController alloc] init];
    wordCheckViewCon.delegate = self;
    wordCheckViewCon.hidesBottomBarWhenPushed = YES;
    [wordCheckViewCon loadData:arrWord];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wordCheckViewCon];
    [self.firstViewController presentViewController:nav animated:YES completion:nil];
}


#pragma mark - HSWordCheckDelegate
-(void)clickWordCheckBackBtnAndIsNextLevel:(BOOL)isnextLevel{
    //返回到关卡页面
    /*
    if (isnextLevel)
    {
        for (UIViewController *temp in self.firstViewController.navigationController.viewControllers) {
            if ([temp isKindOfClass:[HSHomeViewController class]]) {
                [self.firstViewController.navigationController popToViewController:temp animated:NO];
                break;
            }
        }
    }
    */
    //返回到列表页面
//    [self.firstViewController.navigationController popViewControllerAnimated:YES];
    HSWordLearnViewController *con = (HSWordLearnViewController *)self.firstViewController;
    [con backJumpToNextLevel:isnextLevel];
}

@end
