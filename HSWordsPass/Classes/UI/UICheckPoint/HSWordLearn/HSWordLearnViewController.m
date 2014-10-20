//
//  HSWordLearnViewController.m
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordLearnViewController.h"
#import "HSWordCheckViewController.h"

#import "UINavigationController+Extern.h"

#import "HSWordLearnView.h"



@interface HSWordLearnViewController ()

@property (nonatomic, assign) BOOL isAddNewWord;
@property (nonatomic, strong) UIImage *editNewWordsImg;



@end

@implementation HSWordLearnViewController
{
    CGRect frame;
    HSWordLearnView *wordLearnView;
    
    UIImage *imgNavBack;
    NSMutableArray *wordModelArray;
    
    BOOL isFirstInto;//是否第一次进入，如果是第一次 则通过view will apper加载 否则不
}

#pragma mark - 初始化操作等


-(id)initWithModelArray:(NSArray *)modelArray index:(NSInteger)index
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        wordModelArray = [[NSMutableArray alloc] initWithCapacity:2];
        [wordModelArray setArray:modelArray];
        
        _curIndex = index;
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = NSLocalizedString(@"词汇学习", @"");
    
    isFirstInto = YES;
    
    imgNavBack = [UIImage imageNamed:@"hsGlobal_back_icon.png"];
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:imgNavBack];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (isFirstInto) {
        [self loadWordLearnViewWithPointWordIndex:_curIndex];
        isFirstInto = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [CommonHelper googleAnalyticsPageView:@"词汇学习"];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    //先停止掉所有的音频
    [[AudioPlayHelper sharedManager] stopAudio];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - 词语详情视图
- (void)loadWordLearnViewWithPointWordIndex:(NSInteger)index
{
    frame = [UIScreen mainScreen].applicationFrame;
    
    CGFloat top =  kIOS7 ? (frame.origin.y + kNavigationBarHeight) : 0;
    
    if (!wordLearnView)
    {
        wordLearnView = [[HSWordLearnView alloc] initWithFrame:CGRectMake(0, top, frame.size.width, frame.size.height-kNavigationBarHeight)];
        
        
        [self.view addSubview:wordLearnView];
    }
    
    //加载数据
    wordLearnView.currentPageNum = index;
    wordLearnView.willPageNum = index;
    [wordLearnView loadDataWithModelArray:wordModelArray];
}

-(void)backJumpToNextLevel:(BOOL)isnextLevel{
    [self.navigationController popViewControllerAnimated:YES];
    if (isnextLevel) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToNextLevel)]) {
            [self.delegate jumpToNextLevel];
        }
    }
}


#pragma mark - Memory Manager
- (void)dealloc
{
    imgNavBack = nil;
    _curIndex = 0;
    [wordModelArray removeAllObjects];
    wordModelArray = nil;
}


@end
