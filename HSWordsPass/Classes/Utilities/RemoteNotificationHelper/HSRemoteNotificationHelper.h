//
//  HSRemoteNotificationHelper.h
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kDeviceTokenRegisteredKey @"DeviceTokenReigstered"
#define kDeviceTokenStringKey     @"DeviceToken"

@interface HSRemoteNotificationHelper : NSObject

+ (void)registerForRemoteNotificationToGetToken;

+ (void)sendProviderDeviceToken:(NSString *)deviceTokenString;

+ (void)resetBadgeNumberOnProviderWithDeviceToken:(NSString *)deviceTokenString;

@end
