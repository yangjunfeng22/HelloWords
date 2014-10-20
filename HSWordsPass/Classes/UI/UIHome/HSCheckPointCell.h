//
//  HSCheckPointCell.h
//  HSWordsPass
//
//  Created by yang on 14-10-13.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CheckPointModel;

@protocol HSCheckPointCellDelegate;

@interface HSCheckPointCell : UITableViewCell

@property (weak, nonatomic) id<HSCheckPointCellDelegate>delegate;
@property (nonatomic) NSInteger row;
@property (nonatomic) NSInteger totalCount;
@property (nonatomic) BOOL isLast;
@property (nonatomic) BOOL isOdd;

@property (nonatomic) CheckPointModel *firstCheckPoint;
@property (nonatomic) CheckPointModel *secondCheckPoint;
@property (nonatomic) CheckPointModel *thirdCheckPoint;

@property (readonly, nonatomic) UIImageView *imgvLinkFirst;
@property (readonly, nonatomic) UIImageView *imgvLinkSecond;
@property (readonly, nonatomic) UIImageView *imgvLinkThird;

- (void)initCheckPointAndStatus;

@end

@protocol HSCheckPointCellDelegate <NSObject>

@optional
- (void)cell:(HSCheckPointCell *)cell selectedCheckPoint:(CheckPointModel *)checkPoint;
- (void)cell:(HSCheckPointCell *)cell syncWordLearnRecordsFinished:(NSString *)cpID;

@end