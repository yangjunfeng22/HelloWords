//
//  HSWordCheckTopicBaseView.h
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSWordCheckDataFormat.h"

#import "HSWordCheckTopicChoiceCHWord.h"
#import "HSWordCheckTopicChoiceFromLocal.h"
#import "HSWordCheckTopicChoiceFromCH.h"
#import "WordModel.h"
#import "TopicLabel.h"


#pragma mark - HSWordCheckTopicCell
@interface HSWordCheckTopicCell: UITableViewCell

@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)TopicLabel *resultLabel;

@end





#pragma mark - HSWordCheckTopicManageView
@class HSWordCheckTopicManageView;
@protocol HSWordCheckTopicManageViewDelegate <NSObject>

@optional
- (void)choiceResultItemAndResult:(BOOL)isTrue;

@end



@interface HSWordCheckTopicManageView : UIView<UITableViewDataSource,UITableViewDelegate,HSWordCheckTopicManageViewDelegate>

@property (nonatomic, strong)UIView *topTopicView;//题目view
@property (nonatomic, strong)UITableView *resultTableView;//答案
@property (nonatomic, strong)NSArray *resultCellArr;//答案数组

@property (nonatomic, weak) id<HSWordCheckTopicManageViewDelegate> delegate;


- (id)initWithHSWordCheckTopicType:(HSWordCheckTopicType) type;

- (void)playWordAudio;

/**
 * model 改题的模型
 * modelArr 包含该题的 四个答案模型
 */
- (void)loadDataWithModel:(WordModel *)model aneResultModelArr:(NSArray *)modelArr;


@end
