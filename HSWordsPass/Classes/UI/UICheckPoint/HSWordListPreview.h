//
//  HSWodListPreview.h
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSWordListPreviewDelegate;

@interface HSWordListPreview : UIView<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) id<HSWordListPreviewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tbvWordList;
@property (weak, nonatomic) IBOutlet UIButton *btnStartLearn;
@property (weak, nonatomic) IBOutlet UIButton *btnStartCheck;

/**
 *  初始化函数，从nib文件中获取对象
 *
 *  @return 该对象实例。
 */
+ (HSWordListPreview *)instance;

- (void)refreshWordList;
- (void)clearnCachedData;

@end


@protocol HSWordListPreviewDelegate <NSObject>

@optional

- (void)wordListPreView:(HSWordListPreview *)view selectedWord:(NSString *)wID;

//新版 传递点击位置
- (void)wordListPreView:(HSWordListPreview *)view selectedWordIndex:(NSInteger)index;


- (void)wordListPreView:(HSWordListPreview *)view startToLearn:(NSInteger)wCount;

/**
 *  开始测试
 *
 *  @param view   HSWordListPreview
 *  @param wCount 词汇的数量
 */
- (void)wordListPreView:(HSWordListPreview *)view startToCheck:(NSInteger)wCount;


@end