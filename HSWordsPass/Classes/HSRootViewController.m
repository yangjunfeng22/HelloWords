//
//  HSRootViewController.m
//  HSWordsPass
//
//  Created by yang on 14-8-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSRootViewController.h"
#import "UINavigationController+Extern.h"

#import "HSLoginViewController.h"
#import "HSHomeViewController.h"

#import "HSUIAnimateHelper.h"

#import "NFSinaWeiboHelper.h"
#import "HSTwitterHelper.h"
#import "FileHelper.h"

#import "UserDAL.h"
#import "UserModel.h"

NSString *const kQuitLoginNotification = @"QuitLoginNotification";

@interface HSRootViewController ()
{
    HSLoginViewController *loginViewController;
    HSHomeViewController *homeViewController;
}

@end

@implementation HSRootViewController

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
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    //[self.navigationController setNavigationBarShadow];
    /*
    NSDictionary *dic = @{@"name":@"hello", @"sex":@"man"};
    [[FileHelper sharedInstance] createDirectory:kDownloadedPath];
    NSString *filePath = [kDownloadedPath stringByAppendingPathComponent:@"dic.txt"];
    [dic writeToFile:filePath atomically:YES];
    BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    DLog(@"path: %@; exit : %d", filePath, exit);
     */
    
    [self initUserLogoutNotification];
    
    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    if (user.loginedValue){
        [self pushToHomeViewController];
    }else{
        [self pushToLoginViewController];
    }
}

+ (void)load
{
    DLOG_CMETHOD;
}

#pragma mark - 用户登出的处理
- (void)initUserLogoutNotification
{
    kAddObserverNotification(self, @selector(dealUserLogoutNotification:), kQuitLoginNotification, nil);
}

- (void)dealUserLogoutNotification:(NSNotification *)notification
{
    if (!loginViewController)
    {
        [self buildLoginViewController];
        
        [self.navigationController popToRootViewControllerAnimated:NO];
        CATransition *animation = [HSUIAnimateHelper pushInFromLeftOfCustomView];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:loginViewController animated:YES];
    } 
    
    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    user.loginedValue = NO;
    
    /*
    [NFSinaWeiboHelper logOut:^(NSString *screen_name) {
    
    }];
     */
    
    //测试推特的登出
    //    [hsGetSharedInstanceClass(HSTwitterHelper) logOut:^(NSString *info) {
    //        DLog(@"=====info=%@",info);
    //    }];
}

#pragma mark - 构建控制器
- (void)buildLoginViewController
{
    if (!loginViewController)
    {
        loginViewController = [[HSLoginViewController alloc] initWithNibName:nil bundle:nil];
    }
}

#pragma mark - Push 控制器
- (void)pushToLoginViewController
{
    [self buildLoginViewController];
    [self.navigationController pushViewController:loginViewController animated:NO];
}

- (void)pushToHomeViewController
{
    HSHomeViewController *home = [[HSHomeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:home animated:NO];
}


#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    kRemoveObserverNotification(self, nil, nil);
    loginViewController = nil;
    homeViewController = nil;
}

@end
