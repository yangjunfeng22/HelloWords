//
//  HSWordCheckTopicCardView.h
//  HSWordsPass
//
//  Created by Lu on 14-9-12.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSWordCheckTopicCardViewCon;
@protocol HSWordCheckTopicCardDelegate <NSObject>

@optional
- (void)jumpToTargetTopicPage:(NSInteger)topic;

- (void)submitAndGoToReportView;

@end


#pragma mark - HSWordCheckTopicBtn
@interface HSWordCheckTopicBtn : UIView

@property (nonatomic, strong) UIButton *topicBtn;
@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, assign) BOOL isChoice;

@end



#pragma mark - HSWordCheckTopicCardViewCon
@interface HSWordCheckTopicCardViewCon : UIViewController<HSWordCheckTopicCardDelegate,UIAlertViewDelegate>

-(id)initWithTopicModelCount:(NSInteger)countNum;

@property (nonatomic, strong)UIButton *submitBtn;
@property (nonatomic, weak)id <HSWordCheckTopicCardDelegate> delegate;
@property (nonatomic, weak)NSArray *topicModelArray;


- (void)loadDataWithAllTopicArray:(NSArray *)topicModelArray;

@end
