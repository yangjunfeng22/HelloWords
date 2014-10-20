//
//  CommonHelper.m
//  HSWordsPass
//
//  Created by Lu on 14-10-13.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CommonHelper.h"
#import "GAIDictionaryBuilder.h"

@implementation CommonHelper



#pragma mark - 谷歌分析 页面访问记录
+ (void)googleAnalyticsPageView:(NSString *)pageName
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:pageName];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

+ (void)googleAnalyticsLogCategory:(NSString *)category action:(NSString *)action event:(NSString *)event pageView:(NSString *)pageName
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:pageName];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:event
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}



@end
