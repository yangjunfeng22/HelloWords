//
//  HSUserRegistView.m
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSUserRegistView.h"
#import "HSRegisterAreaView.h"
#import "CustomKeyChainHelper.h"
#import "PredicateHelper.h"
#import "MessageHelper.h"
#import "MBProgressHUD.h"
#import "ResponseModel.h"

#import "UserNet.h"

@implementation HSUserRegistView
{
    HSRegisterAreaView *regAreaView;
    
    
    UITextField *tfEmail;
    UITextField *tfPassword;
    UITextField *tfRepassword;
    
    UIImage *imgBtnReg;
    UIButton *btnRegister;
    UserNet *userNet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HSUserRegistView *)instance
{
    NSArray *registView = [[NSBundle mainBundle] loadNibNamed:@"HSUserRegistView" owner:nil options:nil];
    return [registView lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self loadImage];
        
        userNet = [[UserNet alloc] init];
        self.tbvRegist.tableFooterView = [[UIView alloc] init];
        self.tbvRegist.width = self.width;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //DLog(@"self.width: %f", self.width);
}

#pragma mark - 加载/卸载图片
- (void)loadImage
{
    imgBtnReg = [UIImage imageNamed:@"btnLogin.png"];
}

- (void)unLoadImage
{
    imgBtnReg = nil;
}

#pragma mark - UIButton Action Manager
// 注册操作
- (void)registerAction:(id)sender
{
    NSString *email = tfEmail.text;
    NSString *password = tfPassword.text;
    
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
    if (![self isPasswordSameWithConfirm])
    {
        [MessageHelper showMessage:NSLocalizedString(@"两次输入密码不一致", @"") view:self];
        return;
    }
    
    [self hideKeyBoard];
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = NSLocalizedString(@"注册", @"");
    [userNet startRegistWithUserEmail:email password:password completion:^(BOOL finished, id result, NSError *error) {
        // 关闭该hud
        [hud hide:YES];
        DLog(@"finished: %d; error: %@", finished, error.localizedDescription);
        if (error.code == 0)
        {
            // 保存登陆信息
            [CustomKeyChainHelper saveUserName:email userNameService:KEY_USERNAME password:password passwordService:KEY_PASSWORD];
            // 注册成功之后直接登陆
            [self registSuccess];
        }
        else
        {
            // 显示信息
            [MessageHelper showMessage:error.domain view:self];
        }
    }];
}

- (BOOL)isPasswordSameWithConfirm
{
    if (tfPassword && tfRepassword && [tfPassword.text isEqualToString:tfRepassword.text])
    {
        return YES;
    }
    return NO;
}

- (void)hideKeyBoard
{
    [tfEmail resignFirstResponder];
    [tfPassword resignFirstResponder];
    [tfRepassword resignFirstResponder];
}

#pragma mark - 网络请求管理
- (void)registSuccess
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userRegistSuccessedWithEmail:password:)])
    {
        [self.delegate userRegistSuccessedWithEmail:tfEmail.text password:tfPassword.text];
    }
}

- (void)showMessage:(NSString *)message
{
    [MessageHelper showMessage:message view:self];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
        cell.backgroundView = [[UIView alloc] init];
        cell.width = self.width;
    }
    
    NSInteger row = [indexPath row];
    
    switch (row)
    {
        case 0:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            regAreaView = [HSRegisterAreaView instance];
            regAreaView.frame = CGRectMake((cell.contentView.bounds.size.width - 297.0f)*0.5f, 8.0f, 297.0f, 148.0f);
            regAreaView.backgroundColor = [UIColor whiteColor];
            regAreaView.layer.cornerRadius = 8.0f;
            regAreaView.layer.borderWidth = 0.16f;
            [cell.contentView addSubview:regAreaView];
            
            tfEmail = regAreaView.tfEmail;
            tfEmail.placeholder = @"example@mail.com";
            tfPassword = regAreaView.tfPassword;
            tfPassword.placeholder = NSLocalizedString(@"6-16个字符", @"");
            tfRepassword = regAreaView.tfRepassword;
            tfRepassword.placeholder = NSLocalizedString(@"再次输入您的密码", @"");
            tfEmail.delegate = self;
            tfPassword.delegate = self;
            tfRepassword.delegate = self;
            break;
        }
        case 1:
        {
            btnRegister = [UIButton buttonWithType:UIButtonTypeCustom];
            btnRegister.frame = CGRectMake((tableView.bounds.size.width - 297.0f)*0.5f, 0.0f, 297.0f, 41.0f);
            btnRegister.width = self.width*0.9f;
            btnRegister.centerX = self.width/2;
            [btnRegister setBackgroundImage:imgBtnReg forState:UIControlStateNormal];
            [btnRegister setTitle:NSLocalizedString(@"注册", @"") forState:UIControlStateNormal];
            [btnRegister addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnRegister];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = tableView.rowHeight;
    NSInteger row = [indexPath row];
    if (0 == row)
    {
        rowHeight = 165.0f;
    }
    return rowHeight;
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:tfEmail])
    {
        [tfPassword becomeFirstResponder];
    }
    else if ([textField isEqual:tfPassword])
    {
        [tfRepassword becomeFirstResponder];
    }
    else
    {
        [self registerAction:btnRegister];
    }
    return YES;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [self unLoadImage];
    [self hideKeyBoard];
    
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
    
    [_tbvRegist removeFromSuperview];
    self.tbvRegist = nil;
    
    [regAreaView removeFromSuperview];
    regAreaView = nil;
    
    [tfEmail removeFromSuperview];
    tfEmail = nil;
    
    [tfPassword removeFromSuperview];
    tfPassword = nil;
    
    [tfRepassword removeFromSuperview];
    tfRepassword = nil;
    
    imgBtnReg = nil;;
    [btnRegister removeFromSuperview];
    btnRegister = nil;
    
    [regAreaView removeFromSuperview];
    regAreaView = nil;
    
    userNet = nil;
}

@end
