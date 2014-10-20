//
//  HSUserLoginView.h
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSUserLoginViewDelegate;

@interface HSUserLoginView : UIView<UITextFieldDelegate>

@property (nonatomic, weak)id<HSUserLoginViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnRegist;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnSina;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPassword;
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;

/**
 *  初始化函数，从nib文件中获取对象
 *
 *  @return 该对象实例。
 */
+ (HSUserLoginView *)instance;

/**
 *  关闭键盘
 */
- (void)hideKeyboard;

// 刷新用户的邮箱内容
- (void)refreshUserEmailContent;

@end

@protocol HSUserLoginViewDelegate <NSObject>

@optional

/**
 *  用户按下了注册按钮，那么就需要跳转到注册界面去。
 *
 *  @param view  当前的登陆view
 *  @param email 传递的email。
 */
- (void)loginView:(HSUserLoginView *)view clickedRegisterWithEmail:(NSString *)email;

/**
 *  用户使用了email注册的方式注册，然后使用该注册的email登陆。
 *
 *  @param email    email
 *  @param password 密码。
 */
- (void)userLoginSuccessedWithEmail:(NSString *)email password:(NSString *)password;

/**
 *  用户使用新浪微博登陆成功。
 *
 *  @param userID 用户ID
 *  @param name   用户名称
 */
- (void)userLoginSUccessedWithSinaweiboID:(NSString *)userID email:(NSString *)email name:(NSString *)name token:(NSString *)token;

/**
 *  用户使用facebook登陆成功
 *
 *  @param userID 用户ID
 *  @param email  email
 *  @param name   用户名称
 */
- (void)userLoginSuccessedWithFacebookID:(NSString *)userID email:(NSString *)email name:(NSString *)name token:(NSString *)token;



/**
 *  用户使用twitter登陆成功
 *
 *  @param userID 用户ID
 *  @param email  email
 *  @param name   用户名称
 */
- (void)userLoginSuccessedWithTwitterID:(NSString *)userID imageUrl:(NSString *)imageUrl name:(NSString *)name token:(NSString *)token;


@end
