//
//  HSLoginViewController.m
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSLoginViewController.h"
#import "HSHomeViewController.h"
#import "HSRegistViewController.h"

#import "HSUserLoginView.h"
#import "UserDAL.h"
#import "UserModel.h"


@interface HSLoginViewController ()<HSUserLoginViewDelegate>
{
    HSUserLoginView *loginView;
}

@end

@implementation HSLoginViewController

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
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationItem setHidesBackButton:YES];
    
    [self initKeyBorderNotification];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // LoginView
    [self layoutLoginView:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeKeyBorderNotification];
    
    if (loginView) [loginView hideKeyboard];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!loginView)
    {
        loginView = [HSUserLoginView instance];
        loginView.delegate = self;
        [self.view addSubview:loginView];
    }
}

#pragma mark - Notification Manager
// 添加监听键盘的弹出与关闭
- (void)initKeyBorderNotification
{
    //加入键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];//键盘显示触发
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];//键盘显示触发
}

// 移除键盘事件的监听
- (void)removeKeyBorderNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//-------------> 响应键盘显示事件 <------------------------
//    【主要思想是:将整体的view随键盘往上移动】
//------------------------------------------------------
- (void)keyboardWillShow:(NSNotification *)notification
{
    //先设定一个低于键盘顶部的阈值.
    CGFloat startOriginY = loginView.btnLogin.frame.origin.y + loginView.btnLogin.frame.size.height+2.0f;
    NSDictionary *userInfo = [notification userInfo];
    
    //在键盘出现时,获取键盘的顶部坐标
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    CGFloat distanceY = kiPhone ? keyboardTop - startOriginY : 0.0f;
    //根据键盘出现时的动画动态地改变输入区域的显示位置.(即把整个view上下移动)
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图整体往上移动
    //根据键盘的顶部坐标,使输入框自适应,从而不被键盘遮挡.
    CGFloat newCenterY = self.view.center.y + distanceY;
    
    loginView.center = CGPointMake(loginView.center.x, newCenterY);
    [UIView commitAnimations];
}

//-------------> 响应键盘关闭事件 <------------------------
//    【主要思想是:将整体的view随键盘移动到正常位置】
//------------------------------------------------------
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    //获取键盘上下移动时动画的时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //将视图向下恢复到正常位置,并使用动画
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    loginView.center = self.view.center;
    [UIView commitAnimations];
}

#pragma mark - LoginView Manager
- (void)layoutLoginView:(BOOL)animate
{
    if (animate)
    {
        if (loginView)
        {
            if (kIOS7)
            {
                [UIView animateKeyframesWithDuration:0.3f delay:0.0f options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
                    loginView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
                    loginView.center = self.view.center;
                    loginView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
                    loginView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
                    loginView.center = self.view.center;
                    loginView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    
                }];
            }
            
            [loginView refreshUserEmailContent];
        }
    }
    else
    {
        if (loginView)
        {
            loginView.bounds = CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, self.view.bounds.size.height);
            loginView.center = self.view.center;
            loginView.alpha = 1.0f;
            
            [loginView refreshUserEmailContent];
        }
    }
}

#pragma mark - goto Home view
- (void)loginToHome
{
    HSHomeViewController *home = [[HSHomeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:home animated:YES];
    
    UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
    user.loginedValue = YES;
}

#pragma mark - HSUserLoginView Delegate
- (void)loginView:(HSUserLoginView *)view clickedRegisterWithEmail:(NSString *)email
{
    HSRegistViewController *regist = [[HSRegistViewController alloc] initWithEmail:email];
    [self.navigationController pushViewController:regist animated:YES];
    
    
}

- (void)userLoginSuccessedWithEmail:(NSString *)email password:(NSString *)password
{
    [self loginToHome];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:kLoginTypeDefault] forKey:@"UserLoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userLoginSUccessedWithSinaweiboID:(NSString *)userID email:(NSString *)email name:(NSString *)name token:(NSString *)token
{
    [self loginToHome];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:kLoginTypeSina] forKey:@"UserLoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userLoginSuccessedWithFacebookID:(NSString *)userID email:(NSString *)email name:(NSString *)name token:(NSString *)token
{
    [self loginToHome];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:kLoginTypeFacebook] forKey:@"UserLoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)userLoginSuccessedWithTwitterID:(NSString *)userID imageUrl:(NSString *)imageUrl name:(NSString *)name token:(NSString *)token{
    [self loginToHome];
    
    DLog(@"twitter登陆成功==%@====%@=====%@====%@",userID,imageUrl,name,token);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:kLoginTypeTwitter] forKey:@"UserLoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [loginView removeFromSuperview];
    loginView = nil;
}

@end
