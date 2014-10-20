//
//  HSWordCheckViewController.h
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSWordCheckTopicManageView.h"
#import "HSWordCheckTopicCardViewCon.h"
#import "HSWordCheckReportViewCon.h"

@class HSWordCheckViewController;
@protocol HSWordCheckDelegate <NSObject>

@optional
- (void)clickWordCheckBackBtnAndIsNextLevel:(BOOL)isnextLevel;//点击返回按钮的代理

@end


@interface HSWordCheckViewController : UIViewController<HSWordCheckDelegate,UIScrollViewDelegate,HSWordCheckTopicManageViewDelegate,HSWordCheckTopicCardDelegate,HSWordCheckReportViewConDelegate>

@property (nonatomic, weak) id<HSWordCheckDelegate>delegate;

- (void)loadData:(NSArray *)wordModelArrary;

- (void)loadData:(NSArray *)wordModelArrary andIsFromNewWrodInto:(BOOL)isFromNewWrodInto;

@end
