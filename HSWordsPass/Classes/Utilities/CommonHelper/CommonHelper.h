//
//  CommonHelper.h
//  HSWordsPass
//
//  Created by Lu on 14-10-13.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHelper : NSObject


#pragma mark - 谷歌分析 页面访问记录
+ (void)googleAnalyticsPageView:(NSString *)pageName;

+ (void)googleAnalyticsLogCategory:(NSString *)category action:(NSString *)action event:(NSString *)event pageView:(NSString *)pageName;


@end
