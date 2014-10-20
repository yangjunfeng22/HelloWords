//
//  HSRegistViewController.m
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSRegistViewController.h"
#import "HSHomeViewController.h"

#import "HSUserRegistView.h"

#import "UserDAL.h"
#import "UserModel.h"

@interface HSRegistViewController ()<HSUserRegistViewDelegate>
{
    HSUserRegistView *registView;
}

@end

@implementation HSRegistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithEmail:(NSString *)email
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 动画形式过渡，以使切换看起来不会那么生硬。
    self.navigationController.navigationBar.alpha = 0.0f;
    [self.navigationController.navigationBar setHidden:NO];
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.navigationController.navigationBar.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.navigationItem setHidesBackButton:NO];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // 隐藏键盘
    if (registView) [registView hideKeyBoard];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"注册", @"");
    self.view.backgroundColor = kWhiteColor;
    CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"hsGlobal_back_icon.png"], @selector(backBtnClick:), self, YES);
    
    if (!registView)
    {
        registView = [HSUserRegistView instance];
        registView.width = self.view.width;
        registView.delegate = self;
        [self.view addSubview:registView];
    }
}

- (void)backBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - goto Home view
- (void)loginToHome
{
    HSHomeViewController *home = [[HSHomeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:home animated:YES];
    
    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    user.loginedValue = YES;
}

#pragma mark - RegistView delegate
- (void)userRegistSuccessedWithEmail:(NSString *)email password:(NSString *)password
{
    [self loginToHome];
}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [registView removeFromSuperview];
    registView = nil;
}

@end
