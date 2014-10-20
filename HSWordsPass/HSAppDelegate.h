//
//  HSAppDelegate.h
//  HSWordsPass
//
//  Created by yang on 14-7-8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (copy, nonatomic) NSString *curCpID;
@property (copy, nonatomic) NSString *nexCpID;


@property BOOL isNotificationSetBadge;

@end

