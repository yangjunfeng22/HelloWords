//
//  HSUserInfoView.h
//  HSWordsPass
//
//  Created by yang on 14-9-3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THProgressView.h"

@protocol HSUserInfoViewDelegate;

@interface HSUserInfoView : UIView

@property (weak, nonatomic) id<HSUserInfoViewDelegate>delegate;
@property (nonatomic,strong) THProgressView *tHProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *imgvUserHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLearnWord;
@property (weak, nonatomic) IBOutlet UIButton *btnLaterStudy;

/**
 *  初始化函数，从nib文件中获取对象
 *
 *  @return 该对象实例。
 */
+ (HSUserInfoView *)instance;

- (void)refreshUserInfo;

- (void)refreshUserMasteredWords;

@end


@protocol HSUserInfoViewDelegate <NSObject>

@optional

- (void)userGoOnLearn:(HSUserInfoView *)view;

@end