//
//  HSWordCheckReportView.h
//  HSWordsPass
//
//  Created by Lu on 14-9-11.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class wordCell;
@protocol wordCellDelegate <NSObject>
@optional
- (void)wordCellEditWordBtnClick;
@end

@interface wordCell : UITableViewCell<wordCellDelegate>

@property (nonatomic, strong) id<wordCellDelegate> delegate;

- (void)loadData;


@end




@interface HSWordCheckReportView : UIView<UITableViewDataSource,UITableViewDelegate,wordCellDelegate>

- (void)loadData;

@end
