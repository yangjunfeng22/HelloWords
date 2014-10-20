//
//  NFSinaWeiboHelper.h
//  WalkMan
//
//  Created by yang on 14-8-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFSinaWeiboHelper : NSObject

// 注册
+ (void)registerApp;

// 登陆
+ (void)startLogin:(void (^)(NSString *userID, NSString *name, NSString *email, NSString *token))finished;
//+ (void)startLogin:(void (^)(NSString *screen_name))refresh;

// 已经安装了客户端，那么是以客户端的形式来验证的。
//+ (void)startAuthorize:(void (^)(NSString *screen_name))refresh;
// 验证返回
+ (void)authorizeWithResponse:(id)response;

// 已经安装了客户端，那么以客户端的形式来分享信息。
+ (void)startShare:(void (^)(NSString *screen_name))refresh;
// 分享回调
+ (void)sendMessageWithResponse:(id)response;

// 如果没有安装客户端，那么是以网页请求url的形式来验证的。
+ (BOOL)startAuthorizeWithURL:(NSURL *)url finished:(void (^)(NSString *screen_name))refresh;

// 网页验证的url字符串
+ (NSString *)oauthUrlString;
// 网页分享的url字符串
+ (NSString *)shareUrlString;
// 获取token
+ (NSString *)accessToken;
// 获取显示的名字
+ (NSString *)getScreenName;
// 登出
+ (void)logOut:(void (^)(NSString *screen_name))refresh;
// 处理系统回调时的url。
+ (BOOL)handleWBOpenURL:(NSURL *)url delegate:(id)delegate;

@end
