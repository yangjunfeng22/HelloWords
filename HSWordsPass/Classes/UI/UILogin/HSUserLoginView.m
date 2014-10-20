//
//  HSUserLoginView.m
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSUserLoginView.h"
#import "PredicateHelper.h"
#import "CustomKeyChainHelper.h"
#import "MessageHelper.h"
#import "MBProgressHUD.h"
#import "ResponseModel.h"
#import "UserNet.h"

#import "NFSinaweiboHelper.h"
#import "NFFaceBookHelper.h"
#import "HSTwitterHelper.h"


@interface HSUserLoginView ()


@property (nonatomic, strong)UIImageView *logoImgView;

@end


@implementation HSUserLoginView
{
    UserNet *userNet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (HSUserLoginView *)instance
{
    NSArray *loginView = [[NSBundle mainBundle] loadNibNamed:@"HSUserLoginView" owner:nil options:nil];
    return [loginView lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        userNet = [[UserNet alloc] init];
        
        
    }
    return self;
}

- (void)hideKeyboard
{
    [self.tfEmail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.topImageView.backgroundColor = hsShineBlueColor;
    self.logoImgView.backgroundColor = kClearColor;
    self.bottomImageView.backgroundColor = [UIColor colorWithRed:221/255.0 green:241/255.0 blue:254/255.0 alpha:1];
    
    [self.userName setText:NSLocalizedString(@"Email:", @"")];
    [self.userPassword setText:NSLocalizedString(@"密码:", @"")];
    
    [self.userName sizeToFit];
    [self.userPassword sizeToFit];
    self.tfEmail.left = self.userName.right + 10;
    self.tfPassword.left = self.userPassword.right + 10;
    
    [self.btnLogin setTitle:NSLocalizedString(@"登录", @"") forState:UIControlStateNormal];
    [self.btnForgetPassword setTitle:NSLocalizedString(@"忘记密码", @"") forState:UIControlStateNormal];
    [self.btnRegist setTitle:NSLocalizedString(@"免费注册", @"") forState:UIControlStateNormal];
}


-(UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
        UIImage *logoImg = [UIImage imageNamed:@"login_log@2x"];
        _logoImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        _logoImgView.image = logoImg;
        _logoImgView.size = CGSizeMake(90, 90);
        _logoImgView.centerX = self.width/2;
        _logoImgView.centerY = 110;
        [self.topImageView addSubview:_logoImgView];
    }
    return _logoImgView;
}

#pragma mark - UI 刷新管理
// 刷新用户的邮箱内容
- (void)refreshUserEmailContent
{
    NSString *aUserEmail = [CustomKeyChainHelper getUserNameWithService:KEY_USERNAME];
    NSString *password = [CustomKeyChainHelper getPasswordWithService:KEY_PASSWORD];
    if (_tfEmail)
    {
        self.tfEmail.text = aUserEmail ? aUserEmail : @"";
        self.tfPassword.text = password ? password : @"";
    }
}

#pragma mark - Request Success
- (void)loginSuccess
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userLoginSuccessedWithEmail:password:)])
    {
        [self.delegate userLoginSuccessedWithEmail:self.tfEmail.text password:self.tfPassword.text];
    }
}

#pragma mark - 按钮的触发管理
- (IBAction)ibForgetPassword:(id)sender
{
    NSString *lEmail = self.tfEmail.text;
    if (![PredicateHelper validateEmail:lEmail])
    {
        [MessageHelper showMessage:NSLocalizedString(@"请输入邮箱地址", @"") view:self];
        return;
    }
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = NSLocalizedString(@"正在发送消息...", @"");
    [userNet startFindBackUserPasswordWithEmail:lEmail completion:^(BOOL finished, id result, NSError *error) {
        // 组合动画
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            hud.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
                hud.alpha = 1.0f;
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"";
                hud.detailsLabelText = error.domain;
            } completion:^(BOOL finished) {
                [hud hide:YES afterDelay:2.6f];
            }];
        }];
    }];
}

- (IBAction)ibDefaultLogin:(id)sender
{
    NSString *email = self.tfEmail.text;
    NSString *password = self.tfPassword.text;
    
    if (![PredicateHelper validateEmail:email])
    {
        [MessageHelper showMessage:NSLocalizedString(@"请输入邮箱地址", @"") view:self];
        return;
    }
    if (![PredicateHelper validatePassword:password])
    {
        [MessageHelper showMessage:NSLocalizedString(@"请输入6-16个字符的密码", @"") view:self];
        return;
    }
    
    [self hideKeyboard];
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString(@"登录", @"");
    [userNet startLoginWithUserEmail:email password:password completion:^(BOOL finished, id result, NSError *error) {
        // 关闭该hud
        [hud hide:YES];
        DLog(@"finished: %d; error: %@", finished, error.localizedDescription);
        if (error.code == 0)
        {
            // 保存登陆信息
            [CustomKeyChainHelper saveUserName:email userNameService:KEY_USERNAME password:password passwordService:KEY_PASSWORD];
            // 登陆成功
            [self loginSuccess];
        }
        else
        {
            // 显示信息
            [MessageHelper showMessage:error.domain view:self];
        }
    }];
}

- (IBAction)ibWeiboLogin:(id)sender
{
    [NFSinaWeiboHelper startLogin:^(NSString *userID, NSString *name, NSString *email, NSString *token) {
        DLog(@"name: %@", name);
        kSetUDUserID(userID);
        if (self.delegate && [self.delegate respondsToSelector:@selector(userLoginSUccessedWithSinaweiboID: email:name:token:)])
        {
            [self.delegate userLoginSUccessedWithSinaweiboID:userID email:email name:name token:token];
        }
    }];
}


#pragma mark - 第三方推特登陆
- (IBAction)twitterLogin:(id)sender {
    
    [hsGetSharedInstanceClass(HSTwitterHelper) startLogin:^(NSString *userID, NSString *name, NSString *imageUrl, NSString *token) {
        DLog(@"name: %@", name);
        if (self.delegate && [self.delegate respondsToSelector:@selector(userLoginSuccessedWithTwitterID:imageUrl:name:token:)])
        {
            [self.delegate userLoginSuccessedWithTwitterID:userID imageUrl:imageUrl name:name token:token];
        }
    }];
}


// 第三方的facebook登陆
- (IBAction)ibFBLogin:(id)sender
{
    [NFFaceBookHelper startLogin:^(NSString *userID, NSString *name, NSString *email, NSString *token) {
        DLog(@"name: %@", name);
        kSetUDUserID(userID);
        if (self.delegate && [self.delegate respondsToSelector:@selector(userLoginSuccessedWithFacebookID:email:name:token:)])
        {
            [self.delegate userLoginSuccessedWithFacebookID:userID email:email name:name token:token];
        }
    }];
}

- (IBAction)ibRegist:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:clickedRegisterWithEmail:)])
    {
        [self.delegate loginView:self clickedRegisterWithEmail:_tfEmail.text];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:_tfEmail])
    {
        [_tfPassword becomeFirstResponder];
    }
    else if ([textField isEqual:_tfPassword])
    {
        [self ibDefaultLogin:_btnLogin];
    }
    
    return YES;
}


#pragma mark - Memory Manager
- (void)dealloc
{
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

@end
