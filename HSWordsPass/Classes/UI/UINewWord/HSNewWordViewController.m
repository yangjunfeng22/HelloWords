//
//  HSNewWordViewController.m
//  HSWordsPass
//
//  Created by yang on 14-9-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSNewWordViewController.h"
#import "UINavigationController+Extern.h"
#import "HSWordListCell.h"
#import "HSCustomVoiceBtn.h"
#import "CheckPoint_WordModel.h"

#import "HSWordCheckViewController.h"
#import "WordDAL.h"
#import "WordModel.h"
#import "MBProgressHUD.h"
#import "WordReviewModel.h"
#import "UserLaterStatuModel.h"
#import "UserDAL.h"
#import "MBProgressHUD.h"

#import "MJRefresh.h"
#import "HSNewWordLearnViewController.h"
#import "WordNet.h"


#define bottomViewHelght 49
#define loadDataNum 10 //每次请求加载多少数据


@interface HSNewWordViewController ()
{
    WordNet *wordNet;
    // 记录同步按钮是否正在动画中。
    BOOL animating;
}

@property (nonatomic, strong)UITableView *newWordTableView;//生词本tableview
@property (nonatomic, strong)UIView *bottomView; // 底部视图
@property (nonatomic, strong)UIButton *reviewButton;//复习按钮
@property (nonatomic, strong)UIButton *testButton;//测试按钮



@end

@implementation HSNewWordViewController
{
    NSMutableArray *wordArray;//生词数组
    BOOL isEditing;
    NSInteger loadNum;
    NSString *curCpID;
    NSMutableArray *wordModelArray;//词汇数组
    NSMutableArray *userChoiceArray;
    
    UIBarButtonItem *synBtnItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        wordArray = [[NSMutableArray alloc] initWithCapacity:1];
        wordNet = [[WordNet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loadNum = 1;
    
    self.title = NSLocalizedString(@"生词本", @"");
    self.view.backgroundColor = kWhiteColor;
    UIImage *imgNavBack = [UIImage imageNamed:@"hsGlobal_back_icon.png"];
    CreatViewControllerImageBarButtonItem(imgNavBack, @selector(back), self, YES);
    
    
    UIImage *actionImg = [UIImage imageNamed:@"img_newword_choice_icon"];
    UIBarButtonItem *rightBar = CreatViewControllerImageBarButtonItem(actionImg, @selector(actionBtnClick:), self, NO);
    
    UIBarButtonItem *negativeMSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeMSpacer.width = 22.0f;
    
    UIImage *synImg = [UIImage imageNamed:@"synchronization_icon"];
    synBtnItem = CreatViewControllerImageBarButtonItem(synImg, @selector(synchronizationAction:), self, NO);
    
    [self.navigationItem setRightBarButtonItems:@[rightBar, negativeMSpacer, synBtnItem] animated:YES];
    
    self.newWordTableView.backgroundColor = kClearColor;
    self.bottomView.backgroundColor = kClearColor;
    self.reviewButton.backgroundColor = kClearColor;
    self.testButton.backgroundColor = kClearColor;
}


- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //加载数据
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self loadNewWord];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [CommonHelper googleAnalyticsPageView:@"生词本页面"];
}

- (void)loadNewWord
{
    NSArray *arr = [WordDAL fetchNewWordsShowWithUserID:kUserID fetchOffset:0 fetchLimit:loadDataNum];
    [wordArray setArray:arr];
    
    if (!wordArray || wordArray.count == 0) {
        self.testButton.enabled = NO;
        self.reviewButton.enabled = NO;
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:NSLocalizedString(@"暂无数据", @"") isHide:YES];
    }
    
    //少于9个 则不显示加载更多按钮
    if (wordArray.count > (loadDataNum - 1)) {
        [self.newWordTableView addFooterWithTarget:self action:@selector(footerRereshing)];
        self.newWordTableView.footerPullToRefreshText = NSLocalizedString(@"更多。。。", @"");
        self.newWordTableView.footerReleaseToRefreshText = NSLocalizedString(@"松开即可刷新", @"");
        self.newWordTableView.footerRefreshingText = NSLocalizedString(@"正在加载数据", @"");
    }
    
    [self manageWordModelArray];
    [self.newWordTableView reloadData];
}


-(void)dealloc{
    [wordArray removeAllObjects];
    [wordModelArray removeAllObjects];
    wordArray = nil;
    wordModelArray = nil;
    
    wordNet = nil;
}


-(void)viewWillDisappear:(BOOL)animated{
    
    //先停止掉所有的音频
    [[AudioPlayHelper sharedManager] stopAudio];
    
    [super viewWillDisappear:animated];
}

- (void)footerRereshing
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *arr = [WordDAL fetchNewWordsShowWithUserID:kUserID fetchOffset:loadDataNum*loadNum fetchLimit:loadDataNum];
        if (arr.count == 0) {
            [self.newWordTableView footerEndRefreshing];
            return;
        }
        [wordArray addObjectsFromArray:arr];
        [self manageWordModelArray];
        loadNum ++;
        [self.newWordTableView reloadData];
        [self.newWordTableView footerEndRefreshing];
    });
}


- (void)manageWordModelArray{
    
    __weak HSNewWordViewController *weakSelf = self;
    //遍历生词数组 生成词汇数组
    wordModelArray = [NSMutableArray arrayWithCapacity:2];
    [wordArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        WordReviewModel *model = (WordReviewModel *)obj;
        WordModel *word = model.word;
        if (!word || [word isEqual:[NSNull null]])
        {
            // 不存在的话就去下载
            [wordNet startWordRequestWithUserEmail:kEmail checkPointID:model.cpID wordID:model.wID completion:^(BOOL finished, id result, NSError *error) {
                [wordModelArray addObject:model.word];
                [weakSelf.newWordTableView reloadData];
            }];
        }
        else
        {
            [wordModelArray addObject:word];
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - NewWord Synchronous Animation
- (void)startSynchronousAnimation
{
    animating = YES;
    [self spin];
}

- (void)stopSynchronousAnimation
{
    animating = NO;
}

- (void)spin
{
    CABasicAnimation *spinAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    spinAnimation.byValue = [NSNumber numberWithFloat:2*M_PI];
    spinAnimation.delegate = self;
    spinAnimation.duration = 1.0f;
    /*
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.delegate = self;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2 , 0, 0, 1.0)];
    animation.duration = 1;
    animation.cumulative = YES;
    animation.repeatCount = INT_MAX;
     */
    
    [synBtnItem.customView.layer addAnimation:spinAnimation forKey:@"animation"];
}

#pragma mark - Animation Delegates

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (animating)
    {
        [self spin];
    }
}

#pragma mark - action
- (void)synchronizationAction:(id)sender
{
    [CommonHelper googleAnalyticsLogCategory:@"生词本操作" action:@"同步" event:@"同步" pageView:NSStringFromClass([self class])];
    
    __block MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.labelText = NSLocalizedString(@"正在同步数据。。。", @"");
    
    //旋转
    if (!animating)
    {
        synBtnItem.customView.userInteractionEnabled = NO;
        [self startSynchronousAnimation];
    }
    
    NSMutableString *strRecord = [[NSMutableString alloc] initWithCapacity:2];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *arrNewWord = [WordDAL queryAllNewWordsInfosWithUserID:kUserID bookID:kBookID];
        
        for (WordReviewModel *newWord in arrNewWord)
        {
            [strRecord appendFormat:@"%@|%@|%d|%d,", newWord.cpID, newWord.wID, newWord.statusValue, newWord.createdValue];
        }
        if ([strRecord length] > 0) {
            [strRecord setString:[strRecord substringToIndex:[strRecord length]-1]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            DLog(@"strRecord: %@", strRecord);
            [wordNet startSynchronousWordReviewWithUserEmail:kEmail bookID:kBookID records:strRecord completion:^(BOOL finished, id result, NSError *error) {
                [hub hide:YES];
                [self stopSynchronousAnimation];
                
                [self loadNewWord];
                
                synBtnItem.customView.userInteractionEnabled = YES;
            }];
        });
    });
}

- (void)actionBtnClick:(id)sender
{
    if (self.newWordTableView.editing) {
        [self.newWordTableView setEditing:NO animated:YES];
        [userChoiceArray removeAllObjects];
        userChoiceArray = nil;
        self.testButton.enabled = YES;
    }else if (!self.newWordTableView.editing){
        [self.newWordTableView setEditing:YES animated:YES];
        userChoiceArray = [[NSMutableArray alloc] initWithCapacity:2];
        //先将测试按钮关闭
        self.testButton.enabled = NO;
    }
}

- (void)testAction:(id)sender
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:2];
    if (self.newWordTableView.isEditing) {
        [CommonHelper googleAnalyticsLogCategory:@"生词本操作" action:@"用户选择测试" event:@"测试" pageView:(NSStringFromClass([self class]))];
        tempArray = [userChoiceArray mutableCopy];
    }else{
        
        [CommonHelper googleAnalyticsLogCategory:@"生词本操作" action:@"自动测试" event:@"自动测试" pageView:NSStringFromClass([self class])];
        if (wordArray.count < 5) {
            NSString *title = NSLocalizedString(@"抱歉，需要5个以上的词才可以测试", @"");

            [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view detail:title isHide:YES];
            
            return;
        }
        tempArray = [wordModelArray mutableCopy];
    }
    HSWordCheckViewController *checkVC = [[HSWordCheckViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:checkVC];
    [checkVC loadData:tempArray andIsFromNewWrodInto:YES];
    [self presentViewController:nav animated:YES completion:^{
        
    }];

    
    [self.newWordTableView setEditing:NO animated:YES];
}

- (void)reviewAction:(id)sender
{
    //如果是编辑状态  则为多选添加到数组  如果不是  则跳转到详情页面
    NSMutableArray *tempTestArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    if (self.newWordTableView.isEditing) {
        
        [CommonHelper googleAnalyticsLogCategory:@"生词本操作" action:@"用户选择复习" event:@"复习" pageView:(NSStringFromClass([self class]))];
        
        
        if (userChoiceArray.count == 0) {
            tempTestArray = [wordModelArray mutableCopy];
        }else{
            tempTestArray = [userChoiceArray mutableCopy];
        }
        HSNewWordLearnViewController *newLearnVC = [[HSNewWordLearnViewController alloc] initWithNewWordModelArray:tempTestArray index:0 isFromChoice:YES];
        
        [self.navigationController pushViewController:newLearnVC animated:YES];
        
    }else{
        
        [CommonHelper googleAnalyticsLogCategory:@"生词本操作" action:@"自动复习" event:@"自动复习" pageView:NSStringFromClass([self class])];
        
        
        tempTestArray = [wordModelArray mutableCopy];
        
        HSNewWordLearnViewController *newLearnVC = [[HSNewWordLearnViewController alloc] initWithNewWordModelArray:tempTestArray index:0 isFromChoice:NO];
        
        [self.navigationController pushViewController:newLearnVC animated:YES];
    }
    [self.newWordTableView setEditing:NO animated:YES];
}



#pragma mark - 初始化ui等

-(UITableView *)newWordTableView{
    if (!_newWordTableView) {
        _newWordTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        if (kIOS7) {
            _newWordTableView.height -= bottomViewHelght;
        }else{
            _newWordTableView.height -= (bottomViewHelght + 40);
        }
        _newWordTableView.delegate = self;
        _newWordTableView.dataSource = self;
        _newWordTableView.tableFooterView = [[UIView alloc] init];
        _newWordTableView.backgroundColor = kClearColor;
        [self.view addSubview:_newWordTableView];
    }
    return _newWordTableView;
}


-(UIView *)bottomView{
    if (!_bottomView) {
        CGFloat top = kIOS7 ? 0 : kStatusBarHeight*2;
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - bottomViewHelght - top, self.view.width , bottomViewHelght)];
        _bottomView.backgroundColor = kWhiteColor;
        [self.view addSubview:_bottomView];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.width, 1)];
        lineView.backgroundColor = hsGlobalLineColor;
        [self.bottomView addSubview:lineView];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_bottomView.width/2, 0, 1, bottomViewHelght)];
        verticalLine.backgroundColor = hsGlobalLineColor;
        [self.bottomView addSubview:verticalLine];
    }
    return _bottomView;
}


- (UIButton *)reviewButton{
    if (!_reviewButton) {
        _reviewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reviewButton.frame = CGRectMake(0, 0, self.bottomView.width/2, bottomViewHelght);
        [_reviewButton setTitle:NSLocalizedString(@"复习", @"") forState:UIControlStateNormal];
        _reviewButton.backgroundColor = kClearColor;
        [_reviewButton setTitleColor:hsShineBlueColor forState:UIControlStateNormal];
        [_reviewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_reviewButton addTarget:self action:@selector(reviewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_reviewButton];
    }
    return _reviewButton;
}

- (UIButton *)testButton{
    if (!_testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _testButton.frame = CGRectMake(self.bottomView.width/2, 0, self.bottomView.width/2, bottomViewHelght);
        [_testButton setTitle:NSLocalizedString(@"测试", @"") forState:UIControlStateNormal];
        _testButton.backgroundColor = kClearColor;
        [_testButton setTitleColor:hsShineBlueColor forState:UIControlStateNormal];
        [_testButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_testButton addTarget:self action:@selector(testAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_testButton];
    }
    return _testButton;
}
#pragma mark - tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [wordArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellIdentifier = @"Cell";
    HSWordListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[HSWordListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.highlightedTextColor = kWhiteColor;
        
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.highlightedTextColor = kWhiteColor;
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //如果是编辑状态  则为多选添加到数组  如果不是  则跳转到详情页面
    if (tableView.isEditing) {
        WordModel *tempModel = [wordModelArray objectAtIndex:indexPath.row];
        [userChoiceArray addObject:tempModel];
        //编辑测试按钮状态
        if (userChoiceArray.count >= 5) {
            self.testButton.enabled = YES;
        }
        
    }else{
        HSNewWordLearnViewController *newLearnVC = [[HSNewWordLearnViewController alloc] initWithNewWordModelArray:wordModelArray index:indexPath.row isFromChoice:NO];
        [self.navigationController pushViewController:newLearnVC animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        WordModel *tempModel = [wordModelArray objectAtIndex:indexPath.row];
        [userChoiceArray removeObject:tempModel];
         //编辑测试按钮状态
        if (userChoiceArray.count < 5){
            self.testButton.enabled = NO;
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLOG_CMETHOD;
    if (tableView == self.newWordTableView) {
        
        return tableView.editing ? UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert : UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        NSInteger row = [indexPath row];
        WordReviewModel *wordReviewModel = [wordArray objectAtIndex:row];
        [WordDAL saveWordReviewWithUserID:kUserID cpID:nil wordID:wordReviewModel.wID created:012 status:NewWordStatusRemoved completion:^(BOOL finished, id obj, NSError *error) {
            
            [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:NSLocalizedString(@"删除成功", @"") isHide:YES position:HUDYOffSetPositionCenter];
            
            //删除数据源数组相对数据
            [wordArray removeObjectAtIndex:row];
        
            //保存至本地  并同步到服务器等
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView endUpdates];
        }];
    }  
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"删除", @"");
}


- (void)configureCell:(HSWordListCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    WordReviewModel *wordReviewModel = (WordReviewModel *)[wordArray objectAtIndex:indexPath.row];
    WordModel *wordModel = wordReviewModel.word;
    
    NSString *text = [[NSString alloc] initWithFormat:@"%@\n%@", wordModel.pinyin, wordModel.chinese];
    cell.textLabel.text = text;
    [cell.textLabel sizeToFit];
    cell.detailTextLabel.text = wordModel.tChinese;
    cell.cpID = wordReviewModel.cpID;
    cell.audio = wordModel.audio;
    cell.tAudio = [wordModel tAudio];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


@end
