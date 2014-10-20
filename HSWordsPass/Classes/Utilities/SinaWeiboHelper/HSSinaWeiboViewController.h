//
//  HSSinaWeiboViewController.h
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WeiboType) {
    kWeiboTypeLogin = 0,
    kWeiboTypeShare = 1
};

@interface HSSinaWeiboViewController : UIViewController

- (id)initwithWeiboType:(WeiboType)type;

@end
