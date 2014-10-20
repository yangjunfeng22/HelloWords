//
//  HSWordListViewController.m
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordListViewController.h"
#import "HSWordListPreview.h"

#import "UINavigationController+Extern.h"

#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "WordLearnInfoModel.h"
#import "WordDAL.h"
#import "HSAppDelegate.h"

#import "UserLaterStatuModel.h"
#import "UserDAL.h"

#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "CheckPointProgressModel.h"

#import "WordModel.h"
#import "WordNet.h"
#import "WordDAL.h"
#import "MBProgressHUD.h"

#define kBottomDistance 60.0f

@interface HSWordListViewController ()<HSWordListPreviewDelegate>
{
    HSWordListPreview *wordListPreView;
    UIImage *imgNavBack;
    
    NSString *curCpID;
    
    WordNet *wordNet;
    CheckPointNet *checkPointNet;
}

@end

@implementation HSWordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        curCpID = kAppDelegate.curCpID;
        // Custom initialization
        __weak HSWordListViewController *weakSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithBookID:kBookID checkPointID:curCpID];
            
            NSString *title = checkPoint.name;
            if ([[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
            {
                NSString *tempTitle = NSLocalizedString(@"第_关", @"");
                NSString *numStr = [NSString stringWithFormat:@"%i",checkPoint.indexValue];
                title = [tempTitle stringByReplacingOccurrencesOfString:@"_" withString:numStr];
            }
        
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.title = title;
            });
        });
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[AudioPlayHelper sharedManager] stopAudio];
    
    [wordListPreView clearnCachedData];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imgNavBack = [UIImage imageNamed:@"hsGlobal_back_icon.png"];
    
    CreatViewControllerImageBarButtonItem(imgNavBack, @selector(pop:), self, YES);
    
    if (!wordListPreView)
    {
        wordListPreView = [HSWordListPreview instance];
        wordListPreView.delegate = self;
        [self.view addSubview:wordListPreView];
    }
    
    [self layoutWordListPreView:YES];
    
    wordNet = [[WordNet alloc] init];
    checkPointNet = [[CheckPointNet alloc] init];

    NSInteger wordCount = [WordDAL wordCountWithCheckPointID:curCpID];
    
    // 如果一开始没有词汇，那么添加这个加载的视图。
    if (wordCount <= 0)
    {
        MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hub.labelText = NSLocalizedString(@"正在下载数据", @"");
        // 获取关卡数据
        [self requestWordListDataWithCheckPointID:curCpID];
    }
    else
    {
        NSInteger newCount = [WordDAL newWordCountWithUserID:kUserID checkPointID:curCpID];
        if (wordCount == newCount){
            // 获取关卡数据
            [self requestWordListDataWithCheckPointID:curCpID];
        }else{
            // 检查关卡版本
            [self checkPointVersionWithID:curCpID];
        }
    }
}

- (void)pop:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldRefreshUserInfoAndReloadCheckPointData:)]){
        [self.delegate shouldRefreshUserInfoAndReloadCheckPointData:curCpID];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestWordListDataWithCheckPointID:(NSString *)cpID
{
    __weak HSWordListViewController *weakSelf = self;
    [wordNet startWordRequestWithUserEmail:kEmail checkPointID:cpID  wordID:NULL completion:^(BOOL finished, id result, NSError *error) {
        //DLog(@"error: %@", error);
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        [weakSelf refreshWordListView];
    }];
}

// 刷新词汇列表
- (void)refreshWordListView
{
    if (wordListPreView) {
        [wordListPreView refreshWordList];
    }
}

- (void)checkPointVersionWithID:(NSString *)cpID
{
    // 获取关卡版本，如果版本有改变那么更新相应的数据。
    [checkPointNet getCheckPointVersionWithEmail:kEmail cpID:curCpID completion:^(BOOL finished, id result, NSError *error) {
        if (result)
        {
            __weak HSWordListViewController *weakSelf = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                CheckPointProgressModel *cpProgress = [CheckPointDAL queryCheckPointProgressWithUserID:kUserID bookID:kBookID checkPointID:curCpID];
                
                NSString *oVersion = @"";
                if (cpProgress.version){
                    oVersion = cpProgress.version;
                }
                
                NSString *version = [[NSString alloc] initWithFormat:@"%@", result];
                
                // 如果这个版本字段是空的，那么将版本信息写入，且什么都不更新。
                // 因为这表明是第一次使用，数据肯定是最新的。
                if (![oVersion isEqualToString:@""])
                {
                    NSArray *arrVersion  = [version componentsSeparatedByString:@"."];
                    NSArray *arrOVersion = [oVersion componentsSeparatedByString:@"."];
                    NSInteger count = [arrVersion count];
                    NSInteger oCount = [arrOVersion count];
                    
                    // 必须是3个字段，如果不是，那么说明字段有问题。
                    if (count >= 3 && oCount >= 3)
                    {
                        // 第一个字段的比较，如果不一样，那么更新关卡-词对应关系。
                        NSString *link = [arrVersion objectAtIndex:0];
                        NSString *oLink = [arrOVersion objectAtIndex:0];
                        if (![link isEqualToString:oLink])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [wordNet startCheckPointWordsLinkedRequestWithEmail:kEmail checkPointID:curCpID completion:^(BOOL finished, id result, NSError *error) {
                                    [weakSelf refreshWordListView];
                                }];
                            });
                            
                        }
                        // 第二个字段的比较，如果不一样，那么更新词的数据。
                        NSString *data = [arrVersion objectAtIndex:1];
                        NSString *oData = [arrOVersion objectAtIndex:1];
                        if (![data isEqualToString:oData])
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                               [weakSelf requestWordListDataWithCheckPointID:curCpID];
                            });
                        }
                        // 第三个字段的比较，如果不一样，那么重新下载音频。
                        NSString *audio = [arrVersion objectAtIndex:2];
                        NSString *oAudio = [arrOVersion objectAtIndex:2];
                        if (![audio isEqualToString:oAudio])
                        {
                            NSString *dataDir = [kDownloadedPath stringByAppendingPathComponent:cpID];
                            
                            [[NSFileManager defaultManager] removeItemAtPath:dataDir error:nil];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [weakSelf downloadCheckPointMediaDataWithCheckPointID:cpID];
                            });
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"关卡版本： %@", version);
                    [cpProgress setCheckPointVersion:version completion:^(BOOL finished, id obj, NSError *error) {}];
                });
            });
        }
    }];
}

#pragma mark - 数据下载
- (void)downloadCheckPointMediaDataWithCheckPointID:(NSString *)cpID
{
    [checkPointNet downloadCheckPointDataWithEmail:kEmail bookID:kBookID checkPointID:cpID completion:^(BOOL finished, id result, NSError *error) {}];
}

#pragma mark - WorkListPreView Manager
- (void)layoutWordListPreView:(BOOL)animate
{
    if (animate)
    {
        if (wordListPreView)
        {
            if (kIOS7)
            {
                [UIView animateKeyframesWithDuration:0.3f delay:0.0f options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                    wordListPreView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
                    wordListPreView.alpha = 1.0f;
                } completion:^(BOOL finished) {}];
            }
            else
            {
                [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
                    wordListPreView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
                    wordListPreView.alpha = 1.0f;
                } completion:^(BOOL finished) {}];
            }
        }
    }
    else
    {
        if (wordListPreView)
        {
            wordListPreView.frame = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
            wordListPreView.alpha = 1.0f;
        }
    }
}

#pragma mark - HSWordListPreView Delegate
- (void)wordListPreView:(HSWordListPreview *)view startToLearn:(NSInteger)wCount
{
    NSArray *wordInfoArr = [WordDAL queryWordInfosWithCheckPointID:kAppDelegate.curCpID];
    
    HSWordLearnViewController *wordLearn = [[HSWordLearnViewController alloc] initWithModelArray:wordInfoArr index:0];
    wordLearn.delegate = self;
   
    [self.navigationController pushViewController:wordLearn animated:YES];
}

- (void)wordListPreView:(HSWordListPreview *)view startToCheck:(NSInteger)wCount
{
    HSWordCheckViewController *wordCheck = [[HSWordCheckViewController alloc] initWithNibName:nil bundle:nil];
    wordCheck.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wordCheck];
    
    DLog(@"cpID: %@", kAppDelegate.curCpID);
    NSArray *wordArrar = [WordDAL queryWordInfosWithCheckPointID:kAppDelegate.curCpID];
    if (!wordArrar || wordArrar.count == 0) {
        return;
    }
    
    [wordCheck loadData:[wordArrar mutableCopy]];
    
    [self presentViewController:nav animated:YES completion:^{}];
}

-(void)clickWordCheckBackBtnAndIsNextLevel:(BOOL)isnextLevel
{
    if (isnextLevel)
    {
         DLog(@"刷新列表");
        [self.navigationController popViewControllerAnimated:NO];
        NSDictionary *dicInfo = [NSDictionary dictionaryWithObject:kAppDelegate.nexCpID forKey:@"NextCpID"];
        kPostNotification(kNextCheckPointNotification, nil, dicInfo);
    }
    else
    {
        DLog(@"返回至列表页面");
    }
   
}

-(void)jumpToNextLevel
{
    DLOG_CMETHOD;
    [self.navigationController popViewControllerAnimated:NO];
    NSDictionary *dicInfo = [NSDictionary dictionaryWithObject:kAppDelegate.nexCpID forKey:@"NextCpID"];
    kPostNotification(kNextCheckPointNotification, nil, dicInfo);
}

- (void)wordListPreView:(HSWordListPreview *)view selectedWord:(NSString *)wID
{
    
}

-(void)wordListPreView:(HSWordListPreview *)view selectedWordIndex:(NSInteger)index
{
    NSArray *wordInfoArr = [WordDAL queryWordInfosWithCheckPointID:kAppDelegate.curCpID];
    HSWordLearnViewController *wordLearn = [[HSWordLearnViewController alloc] initWithModelArray:wordInfoArr index:index];
    [self.navigationController pushViewController:wordLearn animated:YES];
}


#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[AudioPlayHelper sharedManager] stopAudio];
}

@end
