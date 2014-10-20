//
//  HSTwitterHelper.h
//  HSWordsPass
//
//  Created by Lu on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSTwitterHelper : NSObject

hsSharedInstanceDefClass(HSTwitterHelper)

/**
 * 登陆
 */
- (void)startLogin:(void (^)(NSString *userID, NSString *name, NSString *imageUrl, NSString *token))finished;


/**
 * 登出
 */
- (void)logOut:(void (^)(NSString *))refresh;


/**
 * 处理浏览器返回数据
 */
- (BOOL)handleTwitterOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;


- (NSString *)getScreenName;

@end
