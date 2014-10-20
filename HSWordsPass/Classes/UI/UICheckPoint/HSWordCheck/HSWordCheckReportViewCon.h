//
//  HSWordCheckReportView.h
//  HSWordsPass
//
//  Created by Lu on 14-9-11.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WordModel.h"

@class wordCell;
@protocol wordCellDelegate <NSObject>
@optional
- (void)wordCellEditWordBtnClick:(wordCell *)cell;
@end

@interface wordCell : UITableViewCell<wordCellDelegate>

@property (nonatomic, weak) id<wordCellDelegate> delegate;

- (void)loadDataWithWordModel:(WordModel *)wordModel;


@end

#pragma mark - HSWordCheckReportViewCon

@protocol HSWordCheckReportViewConDelegate <NSObject>

@optional
- (void)reTest;
- (void)backBtnClickAndIsNextLevel:(BOOL)isNextLevel;//返回列表并判断是否是下一关

@end


@interface HSWordCheckReportViewCon : UIViewController<UITableViewDataSource,UITableViewDelegate,wordCellDelegate,HSWordCheckReportViewConDelegate>

@property (nonatomic, weak)id <HSWordCheckReportViewConDelegate> deldgate;

- (id)initWithTopicModleArray:(NSArray *)modelArray;

- (id)initWithTopicModleArray:(NSArray *)modelArray andIsFromNewWrodInto:(BOOL)isFromNewWrodInto;

- (void)loadData;

@end
