//
//  UserNet.h
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNet : NSObject

#pragma mark - block
/**
 *  用户登陆
 *
 *  @param email      email
 *  @param password   密码
 *  @param completion 登陆成功之后通过block返回。
 */
- (void)startLoginWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  用户注册
 *
 *  @param email      email
 *  @param password   密码
 *  @param completion 注册成功之后通过block返回。
 */
- (void)startRegistWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  用户找回密码
 *
 *  @param email      email
 *  @param completion 找回密码成功之后通过block返回。
 */
- (void)startFindBackUserPasswordWithEmail:(NSString *)email completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)cancelLogin;

@end
