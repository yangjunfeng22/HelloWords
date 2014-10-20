//
//  HSHomeViewController.m
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSHomeViewController.h"
#import "HSWordBookTableViewController.h"
#import "HSWordListViewController.h"

#import "BookDAL.h"
#import "UserDAL.h"
#import "UserLaterStatuModel.h"
#import "BookDAL.h"
#import "BookNet.h"
#import "BookModel.h"

#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"

#import "HSUserInfoView.h"
#import "HSCheckPointView.h"
#import "HSNewWordViewController.h"

#import "HSAppDelegate.h"
#import "HSAppSetViewController.h"
#import "GAIDictionaryBuilder.h"

@interface HSHomeViewController ()<HSCheckPointViewDelegate, HSBookSelectDelegate, HSUserInfoViewDelegate, HSWordListDelegate>
{
    
    NSInteger count;
    NSString *curUserID;
    
    BookNet *bookNet;
    
    HSUserInfoView *userInfoView;
    HSCheckPointView *checkPointView;
}

@end

@implementation HSHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    [self layoutUserInfoView:YES];
    [self layoutCheckPointView:YES];
    //[self refreshCheckPointProgress];
    [self refreshUserInfo];
    [self refreshUserMasteredWords];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self refreshTitle];
    self.view.backgroundColor = kWhiteColor;
    
    // 动画形式过渡，以使切换看起来不会那么生硬。
    self.navigationController.navigationBar.alpha = 0.0f;
    [self.navigationController.navigationBar setHidden:NO];
    //[self.navigationItem setHidesBackButton:YES];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.navigationController.navigationBar.alpha = 1.0f;
    } completion:^(BOOL finished) {}];
    
    UIImage *imgHumberg = [UIImage imageNamed:@"imgHumberg.png"];
    CreatViewControllerImageBarButtonItem(imgHumberg, @selector(selectBook:), self, YES);
    
    UIImage *imgSet = [UIImage imageNamed:@"imgSet.png"];
    UIBarButtonItem *rightBar = CreatViewControllerImageBarButtonItem(imgSet, @selector(edit:), self, NO);
    
    UIBarButtonItem *negativeMSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeMSpacer.width = 22.0f;
    
    UIImage *imgNewWord = [UIImage imageNamed:@"new_words_icon"];
    UIBarButtonItem *rightBar1 = CreatViewControllerImageBarButtonItem(imgNewWord, @selector(jumpToNewWordsView:), self, NO);

    [self.navigationItem setRightBarButtonItems:@[rightBar, negativeMSpacer, rightBar1] animated:YES];
    
    // 设置iOS7下面不可以滑动返回
    if (kIOS7) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    bookNet = [[BookNet alloc] init];
    
    curUserID = kUserID;
    count = [UserDAL userLaterStatusCountWithUserID:curUserID];
    if (count <= 0)
    {
        // 进入词书选择界面
        [self goWordBookSelectWithDelay:0.5f];
    }
    // 初始化界面
    [self initInterface];
}

- (void)goWordBookSelectWithDelay:(CGFloat)delay
{
    // 等待delay秒然后再进入界面。

    __weak HSHomeViewController *weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        HSWordBookTableViewController *wordBookViewController = [[HSWordBookTableViewController alloc] initWithStyle:UITableViewStylePlain];
        wordBookViewController.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:wordBookViewController];
        [weakSelf presentViewController:nav animated:YES completion:^{}];
    });
}

#pragma mark - 初始化界面
- (void)initInterface
{
    if (!userInfoView)
    {
        userInfoView = [HSUserInfoView instance];
        userInfoView.delegate = self;
        [userInfoView refreshUserInfo];
        [self.view addSubview:userInfoView];
    }
    
    if (!checkPointView)
    {
        checkPointView = [HSCheckPointView instance];
        checkPointView.delegate = self;
        [self.view addSubview:checkPointView];
        
        [checkPointView reloadCheckPoint];
    }
}

#pragma mark - Refresh Manager
- (void)refreshTitle
{
    __weak HSHomeViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            BookModel *book = (BookModel *)[BookDAL queryWordBookWithCategoryID:kCategoryID bookID:kBookID];
            weakSelf.title = book.tName;
        });
    });
}

- (void)reloadCheckPoints
{
    if (checkPointView) {
        [checkPointView reloadCheckPoint];
    }
}

- (void)reloadVisibleCheckPoints
{
    if (checkPointView) {
        [checkPointView reloadVisibleCheckPoint];
    }
}

- (void)refreshCheckPointProgress
{
    if (checkPointView) {
        [checkPointView refreshCheckPointProgress];
    }
}

- (void)refreshUserInfo
{
    if (userInfoView) {
        [userInfoView refreshUserInfo];
    }
}

- (void)refreshUserMasteredWords
{
    if (userInfoView) {
        [userInfoView refreshUserMasteredWords];
    }
}

#pragma mark - LoginView Manager
- (void)layoutUserInfoView:(BOOL)animate
{
    if (animate)
    {
        if (userInfoView)
        {
            if (kIOS7)
            {
                [UIView animateKeyframesWithDuration:0.3f delay:0.0f options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                    userInfoView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, kiOS7_Y_Offset);
                    userInfoView.center = CGPointMake(self.view.center.x, kiOS7_Y_Offset*1.5f);
                    userInfoView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
                    userInfoView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, kiOS7_Y_Offset);
                    userInfoView.center = CGPointMake(self.view.center.x, kiOS7_Y_Offset*0.5f);
                    userInfoView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
    else
    {
        if (userInfoView)
        {
            userInfoView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, kiOS7_Y_Offset);
            userInfoView.center = CGPointMake(self.view.center.x, kiOS7_Y_Offset);
            userInfoView.alpha = 1.0f;
        }
    }
}

- (void)layoutCheckPointView:(BOOL)animate
{
    if (animate)
    {
        if (checkPointView)
        {
            if (kIOS7)
            {
                [UIView animateKeyframesWithDuration:0.3f delay:0.0f options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                    checkPointView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - 2*kiOS7_Y_Offset);
                    checkPointView.center = CGPointMake(self.view.center.x, 2*kiOS7_Y_Offset + (self.view.bounds.size.height - 2*kiOS7_Y_Offset)*0.5f);
                    //checkPointView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
                    checkPointView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height - kiOS7_Y_Offset);
                    checkPointView.center = CGPointMake(self.view.center.x, kiOS7_Y_Offset + (self.view.bounds.size.height - kiOS7_Y_Offset)*0.5f);
                    //checkPointView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
        }
    }
    else
    {
        if (checkPointView)
        {
            CGFloat yOffset = kiOS7_Y_Offset * (kIOS7 ? 1.5f : 0.5f);
            checkPointView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, kiOS7_Y_Offset);
            checkPointView.center = CGPointMake(self.view.center.x, yOffset);
            //checkPointView.alpha = 1.0f;
        }
    }
}

#pragma mark - Action Manager
- (void)selectBook:(id)sender
{
    [self goWordBookSelectWithDelay:0.0f];
}

- (void)edit:(id)sender
{

    [CommonHelper googleAnalyticsLogCategory:@"进入设置" action:@"进入设置" event:@"设置" pageView:NSStringFromClass([self class])];

    //进入设置页面
    HSAppSetViewController *setVC = [[HSAppSetViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setVC];
    [self presentViewController:nav animated:YES completion:^{}];
}

- (void)jumpToNewWordsView:(id)sender{
    //谷歌
    [CommonHelper googleAnalyticsLogCategory:@"同步生词本" action:@"同步" event:@"同步" pageView:NSStringFromClass([self class])];
    
    HSNewWordViewController *newWordVC = [[HSNewWordViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:newWordVC animated:YES];
}

#pragma mark - 词汇列表界面返回
- (void)shouldRefreshUserInfoAndReloadCheckPointData:(NSString *)curCpID
{
    [self reloadVisibleCheckPoints];
    [self refreshUserMasteredWords];
    
    __weak HSHomeViewController *weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.8f * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [weakSelf refreshCheckPointProgress];
    });
    
}

#pragma mark - 书本选择 Delegate
- (void)bookSelectWithSelBookCategory:(NSString *)cID selBook:(NSString *)bID version:(NSString *)version
{
    [self dismissViewControllerAnimated:YES completion:^{}];

    __weak HSHomeViewController *weakSelf = self;
    [bookNet getBookVersionWithEmail:kEmail bookID:bID completion:^(BOOL finished, id result, NSError *error) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            NSString *oVersion = @"";
            if (version){
                oVersion = version;
            }
            
            NSString *nVersion = [[NSString alloc] initWithFormat:@"%@", result];
            
            if (![oVersion isEqualToString:@""])
            {
                // 版本不一致，需要修改新的关卡了。
                if (![nVersion isEqualToString:oVersion])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@", bID];
                        // 先删除所有旧的关卡数据
                        [CheckPointModel deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext contextForCurrentThread]];
                        // 先删除所有旧的关卡进度的数据
                        [CheckPointProgressModel deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext contextForCurrentThread]];
                        
                        [weakSelf reloadCheckPoints];
                        [weakSelf refreshCheckPointProgress];
                    });
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                DLog(@"词书版本： %@", version);
                BookModel *bookModel = (BookModel *)[BookDAL queryWordBookWithCategoryID:cID bookID:bID];
                [bookModel setBookVersion:version completion:^(BOOL finished, id obj, NSError *error) {}];
            });
        });
    }];
    [self refreshTitle];
    [self reloadCheckPoints];
    [self refreshCheckPointProgress];
}

#pragma mark - UserInfoView Delegate
- (void)userGoOnLearn:(HSUserInfoView *)view
{
    UserLaterStatuModel *userStatu = (UserLaterStatuModel *)[UserDAL queryUserLaterStatusInfoWithUserID:kUserID categoryID:kCategoryID bookID:kBookID];
    
    BOOL empty = [userStatu.checkPointID isEqualToString:@""];
    if (empty)
    {
        CheckPointModel *checkPoint = [CheckPointDAL queryCheckPointWithBookID:kBookID index:1];
        CheckPointModel *nCheckPoint = [CheckPointDAL queryCheckPointWithBookID:kBookID index:2];
        
        NSString *curCpID = checkPoint.cpID;
        NSString *nexCpID = nCheckPoint.cpID;
        
        DLog(@"继续学习: curCpID: %@; nexCpID: %@", curCpID, nexCpID);
        
        kAppDelegate.curCpID = curCpID;
        kAppDelegate.nexCpID = nexCpID;
        
        [UserDAL saveUserLaterStatusWithUserID:kUserID categoryID:kCategoryID bookID:kBookID checkPointID:curCpID nexCheckPointID:nexCpID timeStamp:NSTimeIntervalSince1970 completion:^(BOOL finished, id result, NSError *error) {}];
    }
    else
    {
        kAppDelegate.curCpID = userStatu.checkPointID;
        kAppDelegate.nexCpID = userStatu.nexCheckPointID;
    }
    
    HSWordListViewController *wordListViewController = [[HSWordListViewController alloc] initWithNibName:nil bundle:nil];
    wordListViewController.delegate = self;
    [self.navigationController pushViewController:wordListViewController animated:YES];
}

#pragma mark - CheckPoint Selected Manager
- (void)checkPointView:(HSCheckPointView *)view selectCheckPoint:(NSString *)cpID nexCheckPoint:(NSString *)nexCpID
{
    __weak HSHomeViewController *weakSelf = self;
    [UserDAL saveUserLaterStatusWithUserID:kUserID categoryID:kCategoryID bookID:kBookID checkPointID:cpID nexCheckPointID:nexCpID timeStamp:NSTimeIntervalSince1970 completion:^(BOOL finished, id result, NSError *error) {
        kAppDelegate.curCpID = cpID;
        kAppDelegate.nexCpID = nexCpID;
        HSWordListViewController *wordListViewController = [[HSWordListViewController alloc] initWithNibName:nil bundle:nil];
        wordListViewController.delegate = weakSelf;
        [weakSelf.navigationController pushViewController:wordListViewController animated:YES];
    }];
}

- (void)checkPointView:(HSCheckPointView *)view syncWordLearnRecordsFinished:(NSString *)cpID
{
    [self refreshUserMasteredWords];
}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

@end
