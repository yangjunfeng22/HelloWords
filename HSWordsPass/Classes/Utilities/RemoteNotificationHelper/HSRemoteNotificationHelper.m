//
//  HSRemoteNotificationHelper.m
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSRemoteNotificationHelper.h"
#import "CustomKeyChainHelper.h"
#import "HSAppDelegate.h"

@implementation HSRemoteNotificationHelper

#pragma mark - 消息服务的注册与token的发送
+ (void)registerForRemoteNotificationToGetToken
{
    //NSLog(@"Registering for push notifications...");
    
    // 注册device token， 需要注册remote notification
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 如果没有注册到令牌，则重新发送注册请求
    if (![userDefaults boolForKey:kDeviceTokenRegisteredKey])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        });
    }
    
    // 将远程通知的数量清零
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 1、hide the local badge
        if ([[UIApplication sharedApplication] applicationIconBadgeNumber] == 0) {
            return;
        }
        
        // 2、ask the provider to set the BadgeNumber to zero
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *strDeviceToken = [userDefaults objectForKey:kDeviceTokenStringKey];
        [self resetBadgeNumberOnProviderWithDeviceToken:strDeviceToken];
    });
}

// 发送token
+ (void)sendProviderDeviceToken:(NSString *)deviceTokenString
{
    // Establish the request
    //NSLog(@"sendProviderDeviceToken = %@", deviceTokenString);
    
    //NSString *email = [CustomKeyChainHelper getUserNameWithService:KEY_USERNAME];
    
    //[NotificationNet sendNotificationDeviceTokenWithEmail:email token:deviceTokenString];
}

#pragma mark - 服务器消息数量的设置
+ (void)resetBadgeNumberOnProviderWithDeviceToken:(NSString *)deviceTokenString
{
    
    ((HSAppDelegate *)[UIApplication sharedApplication].delegate).isNotificationSetBadge = YES;
    
    //NSString *email = [CustomKeyChainHelper getUserNameWithService:KEY_USERNAME];
    /*
    ResponseModel *aResponse = [NotificationNet resetNotificationBadgeWithEmail:email token:deviceTokenString];
    if (aResponse.error.code == 0)
    {
        if (isNotificationSetBadge == NO)
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setBool:YES forKey:kDeviceTokenRegisteredKey];
            
        }
        else
        {
            isNotificationSetBadge = NO;
        }
    }
     */
}


@end
