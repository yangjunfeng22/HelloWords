//
//  HSCheckPointView.h
//  HSWordsPass
//
//  Created by yang on 14-9-3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSCheckPointViewDelegate;

@interface HSCheckPointView : UIView<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbvCheckPoint;
@property (nonatomic, weak)id<HSCheckPointViewDelegate>delegate;

/**
 *  初始化函数，从nib文件中获取对象
 *
 *  @return 该对象实例。
 */
+ (HSCheckPointView *)instance;

// 在选择词书之后需要重新加载所有的关卡
- (void)reloadCheckPoint;

- (void)reloadVisibleCheckPoint;

- (void)refreshCheckPointProgress;


@end

@protocol HSCheckPointViewDelegate <NSObject>

@optional

- (void)checkPointView:(HSCheckPointView *)view selectCheckPoint:(NSString *)cpID nexCheckPoint:(NSString *)nexCpID;

- (void)checkPointView:(HSCheckPointView *)view syncWordLearnRecordsFinished:(NSString *)cpID;

@end