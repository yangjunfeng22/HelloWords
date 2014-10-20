//
//  HSWordListViewController.h
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSWordCheckViewController.h"
#import "HSWordLearnViewController.h"

@protocol HSWordListDelegate;

@interface HSWordListViewController : UIViewController<HSWordCheckDelegate,HSWordLearnVCDelegate>
@property (weak, nonatomic) id <HSWordListDelegate>delegate;

@end

@protocol HSWordListDelegate <NSObject>

- (void)shouldRefreshUserInfoAndReloadCheckPointData:(NSString *)curCpID;

@end
